class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Validaciones
  validates :role, presence: true, inclusion: { in: %w[admisión embajador] }
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  # Métodos para verificar roles
  def admision?
    role == 'admisión'
  end

  def embajador?
    role == 'embajador'
  end

  # Métodos para permisos específicos
  def puede_gestionar_eventos?
    admision?
  end

  def puede_ver_estadisticas?
    admision?
  end

  def puede_escanear_qr?
    embajador? || admision?
  end

  def puede_confirmar_asistencia?
    embajador? || admision?
  end
end
