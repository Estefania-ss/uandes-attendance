class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  private

  # Métodos helper para verificar permisos
  def require_admision!
    unless current_user&.admision?
      render json: { error: 'Acceso denegado. Se requieren permisos de admisión.' }, status: :forbidden
    end
  end

  def require_embajador_or_admision!
    unless current_user&.embajador? || current_user&.admision?
      render json: { error: 'Acceso denegado. Se requieren permisos de embajador o admisión.' }, status: :forbidden
    end
  end

  def require_embajador!
    unless current_user&.embajador?
      render json: { error: 'Acceso denegado. Se requieren permisos de embajador.' }, status: :forbidden
    end
  end
end
