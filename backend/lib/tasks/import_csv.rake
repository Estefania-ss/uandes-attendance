namespace :csv do
  desc "Importar datos desde todos los CSV en db/data/ (solo eventos y postulantes)"
  task import: :environment do
    require 'csv'
    
    data_dir = Rails.root.join('db', 'data')
    csv_files = Dir.glob(data_dir.join('*.csv'))
    
    if csv_files.empty?
      puts "No se encontraron archivos CSV en #{data_dir}"
      exit 1
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
      
      CSV.foreach(csv_path, headers: true, encoding: 'UTF-8') do |row|
        begin
          nombre = row['Nombre de la campaña']
          tipo_evento = case
            when nombre =~ /PAES/i then 'PAES'
            when nombre =~ /Zapatilla/i then 'ZAPATILLA'
            when nombre =~ /PDT/i then 'PDT'
            when nombre =~ /DEMRE/i then 'DEMRE'
            else 'Otro'
          end

          existing_event = Event.find_by(campaign_id: row['Id. de campaña'])
          if existing_event
            event = existing_event
          else
            event = Event.create!(
              name: nombre,
              event_type: tipo_evento,
              campaign_id: row['Id. de campaña'],
              date: Date.today
            )
            eventos_creados += 1
            puts "Evento creado: #{event.name} (#{event.event_type})"
          end
          
          applicant = Applicant.find_or_create_by!(rut: row['Rut']) do |a|
            a.name = row['Nombre']
            a.last_name = row['Apellidos']
            a.email = row['Correo electrónico']
            a.school = row['Colegio']
            a.career_interest = row['Carrera 1']
            a.career_interest_2 = row['Carrera 2']
            a.candidate_id = row['Id. de candidato']
            a.graduation_year = row['Año de egreso']
            a.graduation_status = row['Egreso']
            a.phone = row['Móvil']
            a.region = row['Zona Región']
            a.comuna = 'Por definir' 
          end
          postulantes_creados += 1 if applicant.created_at == applicant.updated_at

          attended = row['Asistió'].to_s.strip.downcase.in?(['1', 'true', 'sí', 'si'])
          status_value = attended ? "si" : "no"
          attendance = Attendance.find_or_create_by!(
            applicant: applicant,
            event: event
          ) do |att|
            att.status = status_value
          end
          asistencias_creadas += 1 if attendance.created_at == attendance.updated_at

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