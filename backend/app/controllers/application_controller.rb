class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  layout :layout_by_resource

  private

  def layout_by_resource
    if devise_controller?
      "devise"
    else
      "application"
    end
  end

  # Métodos helper para verificar permisos
  def require_admision!
    unless current_user&.admision?
      respond_to do |format|
        format.html {
          redirect_to root_path, alert: "Acceso denegado. Se requieren permisos de admisión."
        }
        format.json {
          render json: { error: "Acceso denegado. Se requieren permisos de admisión." }, status: :forbidden
        }
      end
    end
  end

  def require_embajador_or_admision!
    unless current_user&.embajador? || current_user&.admision?
      respond_to do |format|
        format.html {
          redirect_to root_path, alert: "Acceso denegado. Se requieren permisos de embajador o admisión."
        }
        format.json {
          render json: { error: "Acceso denegado. Se requieren permisos de embajador o admisión." }, status: :forbidden
        }
      end
    end
  end

  def require_embajador!
    unless current_user&.embajador?
      respond_to do |format|
        format.html {
          redirect_to root_path, alert: "Acceso denegado. Se requieren permisos de embajador."
        }
        format.json {
          render json: { error: "Acceso denegado. Se requieren permisos de embajador." }, status: :forbidden
        }
      end
    end
  end
end
