require 'open3'
require 'json'

class Attendance < ApplicationRecord
  belongs_to :applicant
  belongs_to :event

  before_save :set_predicted_status

  private

  def set_predicted_status
    data = {
      "colegio" => applicant.school,
      "carrera_1" => applicant.career_interest,
      "carrera_2" => applicant.career_interest_2,
      "origen" => event.campaign_id || '',
      "Unnamed: 0" => self.id || 0,
      "año" => applicant.graduation_year.to_i,
      "egresado" => applicant.graduation_status == 'Egresado' ? 1 : 0,
      "lat" => respond_to?(:lat) ? lat : 0.0,
      "lon" => respond_to?(:lon) ? lon : 0.0,
      "distancia" => respond_to?(:distancia) ? distancia : 0.0
    }

    puts "[PREDICT-INPUT] Datos enviados al modelo: #{data.inspect}"

    json_data = data.to_json
    script_path = Rails.root.join('ia_model', 'predict.py')
    cmd = "/usr/bin/python3 #{script_path} '#{json_data}'"
    stdout, stderr, status = Open3.capture3(cmd)
    if status.success?
      # Buscar la última línea que sea un número (la predicción)
      pred = stdout.lines.map(&:strip).select { |l| l =~ /^\d+$/ }.last
      self.predicted_status = pred
    else
      Rails.logger.error("Predicción fallida: #{stderr}")
      self.predicted_status = nil
    end
  end
end
