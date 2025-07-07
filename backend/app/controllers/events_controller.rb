class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: [ :show, :update, :destroy ]
  before_action :require_admision!, only: [ :create, :update, :destroy ]
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
    if @event.update(event_params)
      respond_to do |format|
        format.html { redirect_to @event, notice: "Evento actualizado exitosamente." }
        format.json { render json: @event }
      end
    else
      respond_to do |format|
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
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
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:name, :date, :event_type, :campaign_id)
  end

  def check_event_editable!
    unless @event.date >= Date.current
      respond_to do |format|
        format.html { redirect_to @event, alert: "No se puede editar un evento que ya ha pasado." }
        format.json { render json: { error: "No se puede editar un evento que ya ha pasado." }, status: :unprocessable_entity }
      end
    end
  end

  def event_editable?(event)
    event.date >= Date.current
  end
  helper_method :event_editable?
end
