class AttendancesController < ApplicationController
  protect_from_forgery with: :null_session

  def verify
    rut = params[:rut]
    found = Applicant.exists?(rut: rut)
    render json: { found: found }
  end

  def mark
    applicant = Applicant.find_by(rut: params[:rut])
    if applicant
      applicant.update(attended: true)
      redirect_to events_path, notice: "Asistencia confirmada para #{applicant.name}"
    else
      redirect_to events_path, alert: "El postulante no está en la lista"
    end
  end

  def index
  end

  def show
  end

  def create
  end

  def update
  end

  def destroy
  end

  def toggle_status
    attendance = Attendance.find(params[:id])
    if attendance.status == "confirmado"
      attendance.update(status: "pendiente")
    else
      attendance.update(status: "confirmado")
    end
    redirect_to event_path(attendance.event), notice: "Estado de asistencia actualizado."
  end
end
