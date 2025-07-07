namespace :csv do
  desc "Importar datos desde todos los CSV en db/data/ (solo eventos y postulantes)"
  task import: :environment do
    require "csv"

    data_dir = Rails.root.join("db", "data")
    csv_files = Dir.glob(data_dir.join("*.csv"))

    if csv_files.empty?
      puts "No se encontraron archivos CSV en #{data_dir}"
      exit 1
    end

    # Leer coordenadas de colegios
    coords_path = Rails.root.join("db", "data", "df_coords.csv")
    colegio_coords = {}
    if File.exist?(coords_path)
      CSV.foreach(coords_path, headers: true) do |row|
        # Normalizar nombre de colegio (sin comuna, lowercase, sin espacios extras)
        nombre = row["Colegio"].to_s.split("/").first.strip.downcase
        lat = row["lat"].to_f
        lon = row["lon"].to_f
        colegio_coords[nombre] = [lat, lon]
      end
    else
      puts "[WARNING] No se encontró df_coords.csv, se usarán 0.0 para lat/lon/distancia."
    end

    # Coordenadas UAndes
    uandes_lat = -33.401993
    uandes_lon = -70.567274

    # Método para calcular distancia Haversine
    def haversine(lat1, lon1, lat2, lon2)
      rad_per_deg = Math::PI / 180
      rkm = 6371 # Radio de la Tierra en km
      dlat_rad = (lat2 - lat1) * rad_per_deg
      dlon_rad = (lon2 - lon1) * rad_per_deg
      lat1_rad, lat2_rad = lat1 * rad_per_deg, lat2 * rad_per_deg
      a = Math.sin(dlat_rad / 2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad / 2)**2
      c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1 - a))
      rkm * c
    end

    total_eventos_creados = 0
    total_postulantes_creados = 0
    total_asistencias_creadas = 0
    total_errores = 0

    csv_files.each do |csv_path|
      puts "\nProcesando archivo: #{File.basename(csv_path)}"
      eventos_creados = 0
      postulantes_creados = 0
      asistencias_creadas = 0
      errores = 0

      CSV.foreach(csv_path, headers: true, encoding: "UTF-8") do |row|
        begin
          nombre = row["Nombre de la campaña"]
          tipo_evento = case
          when nombre =~ /PAES/i then "PAES"
          when nombre =~ /Zapatilla/i then "ZAPATILLA"
          when nombre =~ /PDT/i then "PDT"
          when nombre =~ /DEMRE/i then "DEMRE"
          else "Otro"
          end

          # Intentar obtener la fecha real del evento
          raw_date = row["Fecha del evento"] || row["Fecha"] || row["fecha"]
          event_date = nil
          if raw_date.present?
            begin
              # Soporta formatos dd/mm/yyyy y yyyy-mm-dd
              if raw_date =~ %r{\A\d{2}/\d{2}/\d{4}\z}
                event_date = Date.strptime(raw_date, "%d/%m/%Y")
              else
                event_date = Date.parse(raw_date)
              end
            rescue => e
              puts "No se pudo parsear la fecha '#{raw_date}': #{e.message}. Se usará Date.yesterday."
              event_date = Date.yesterday
            end
          else
            event_date = Date.yesterday
          end

          existing_event = Event.find_by(campaign_id: row["Id. de campaña"])
          if existing_event
            event = existing_event
            puts "[LOG] Evento encontrado: #{event.name} (ID: #{event.id})"
          else
            event = Event.create!(
              name: nombre,
              event_type: tipo_evento,
              campaign_id: row["Id. de campaña"],
              date: event_date
            )
            eventos_creados += 1
            puts "[LOG] Evento creado: #{event.name} (#{event.event_type}) (ID: #{event.id})"
          end

          applicant = Applicant.find_or_create_by!(rut: row["Rut"]) do |a|
            a.name = row["Nombre"]
            a.last_name = row["Apellidos"]
            a.email = row["Correo electrónico"]
            a.school = row["Colegio"]
            a.career_interest = row["Carrera 1"]
            a.career_interest_2 = row["Carrera 2"]
            a.candidate_id = row["Id. de candidato"]
            a.graduation_year = row["Año de egreso"]
            a.graduation_status = row["Egreso"]
            a.phone = row["Móvil"]
            a.region = row["Zona Región"]
            a.comuna = "Por definir"
          end
          if applicant.created_at == applicant.updated_at
            postulantes_creados += 1
            puts "[LOG] Applicant creado: #{applicant.name} #{applicant.last_name} (ID: #{applicant.id})"
          else
            puts "[LOG] Applicant encontrado: #{applicant.name} #{applicant.last_name} (ID: #{applicant.id})"
          end

          attended = row["Asistió"].to_s.strip.downcase.in?([ "1", "true", "sí", "si" ])
          status_value = attended ? "confirmado" : "no_confirmado"
          # Buscar coordenadas del colegio
          colegio_nombre = row["Colegio"].to_s.split("/").first.strip.downcase
          lat, lon = colegio_coords[colegio_nombre] || [0.0, 0.0]
          distancia = lat != 0.0 && lon != 0.0 ? haversine(lat, lon, uandes_lat, uandes_lon) : 0.0
          attendance = Attendance.find_or_create_by!(
            applicant: applicant,
            event: event
          ) do |att|
            att.status = status_value
            att.real_status = status_value
            # Pasar lat, lon, distancia reales al callback
            att.define_singleton_method(:lat) { lat }
            att.define_singleton_method(:lon) { lon }
            att.define_singleton_method(:distancia) { distancia }
          end
          if attendance.created_at == attendance.updated_at
            asistencias_creadas += 1
            puts "[LOG] Attendance creada: Applicant #{applicant.id}, Event #{event.id}, Status: #{status_value}, Attendance ID: #{attendance.id}"
          else
            puts "[LOG] Attendance encontrada: Applicant #{applicant.id}, Event #{event.id}, Status: #{status_value}, Attendance ID: #{attendance.id}"
          end

          puts "[LOG] Predicción para Attendance ID #{attendance.id}: #{attendance.predicted_status.inspect}"

        rescue => e
          puts "Error procesando fila: #{e.message}"
          puts "   Datos: #{row.to_h}"
          errores += 1
        end
      end

      puts "\nResumen archivo #{File.basename(csv_path)}:"
      puts "   Eventos creados: #{eventos_creados}"
      puts "   Postulantes creados: #{postulantes_creados}"
      puts "   Asistencias creadas: #{asistencias_creadas}"
      puts "   Errores: #{errores}"
      total_eventos_creados += eventos_creados
      total_postulantes_creados += postulantes_creados
      total_asistencias_creadas += asistencias_creadas
      total_errores += errores
    end

    puts "\nResumen total de importación:"
    puts "   Eventos creados: #{total_eventos_creados}"
    puts "   Postulantes creados: #{total_postulantes_creados}"
    puts "   Asistencias creadas: #{total_asistencias_creadas}"
    puts "   Errores: #{total_errores}"
    puts "   Total de eventos en BD: #{Event.count}"
    puts "   Total de postulantes en BD: #{Applicant.count}"
    puts "   Total de asistencias en BD: #{Attendance.count}"

    puts "\nImportación completada!"
  end
end
