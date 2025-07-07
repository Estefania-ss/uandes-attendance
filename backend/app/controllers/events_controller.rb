class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admision!, only: [ :create, :update, :destroy ]
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :check_event_editable!, only: [ :update, :destroy ]

  


  def index
    @events = Event.all

    # Filtrado por búsqueda
    if params[:search].present?
      search_term = "%#{params[:search]}%"
      @events = @events.where("name ILIKE ? OR event_type ILIKE ?", search_term, search_term)
    end

    # Ordenamiento
    @events = @events.order(date: :desc)

    # Separar eventos en pasados y futuros
    @past_events = @events.where("date < ?", Date.current).order(date: :desc)
    @future_events = @events.where("date >= ?", Date.current).order(date: :asc)

    respond_to do |format|
      format.html
      format.json { render json: @events }
    end
  end

  def show
    selected_school = params[:school].presence
    selected_career = params[:career].presence

    applicants = @event.applicants
    applicants = applicants.where(school: selected_school) if selected_school.present?
    if selected_career.present?
      applicants = applicants.where("career_interest = ? OR career_interest_2 = ?", selected_career, selected_career)
    end

    @filtered_total_applicants = applicants.count
    @filtered_confirmed_attendances = @event.attendances.where(applicant_id: applicants.select(:id), status: "confirmado").count
    @filtered_attendance_rate = if @filtered_total_applicants.zero?
      0
    else
      (@filtered_confirmed_attendances.to_f / @filtered_total_applicants * 100).round(2)
    end
    @filtered_pending = @event.attendances.where(applicant_id: applicants.select(:id), status: "pendiente").count

    @schools = @event.schools
    @careers = @event.careers
    @selected_school = selected_school
    @selected_career = selected_career

    respond_to do |format|
      format.html
      format.json { render json: @event }
    end
  end

  def create
    @event = Event.new(event_params)
    if @event.save
      respond_to do |format|
        format.html { redirect_to @event, notice: "Evento creado exitosamente." }
        format.json { render json: @event, status: :created }
      end
    else
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    check_event_editable! # <- ya tienes @event cargado por el before_action
    if @event.update(event_params)
      redirect_to @event, notice: 'Evento actualizado exitosamente.'
    else
      render :edit
    end
  end
  

  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: "Evento eliminado exitosamente." }
      format.json { head :no_content }
    end
  end

  def new
    @event = Event.new
  end

  def edit
    @event
  end  

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:name, :date, :event_type, :campaign_id)
  end

  def check_event_editable!
    unless @event && @event.date >= Date.current
      respond_to do |format|
        format.html { redirect_to @event || events_path, alert: "No se puede editar un evento que ya ha pasado." }
        format.json { render json: { error: "No se puede editar un evento que ya ha pasado." }, status: :unprocessable_entity }
      end
    end
  end

  def event_editable?(event)
    event.date >= Date.current
  end
  helper_method :event_editable?
end
