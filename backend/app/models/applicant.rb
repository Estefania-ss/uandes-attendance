class Applicant < ApplicationRecord
  has_many :attendances, dependent: :destroy
  has_many :events, through: :attendances
  has_many :room_assignments, dependent: :destroy

  validates :name, presence: true
  validates :rut, presence: true, uniqueness: true
  validates :candidate_id, uniqueness: true, allow_blank: true

  # Métodos helper
  def full_name
    "#{name} #{last_name}".strip
  end

  def primary_career
    career_interest
  end

  def secondary_career
    career_interest_2
  end

  def has_attended_event?(event)
    attendances.exists?(event: event, status: 'confirmado')
  end

  def total_events_attended
    attendances.where(status: 'confirmado').count
  end

  # Scopes para filtros comunes
  scope :by_school, ->(school) { where(school: school) }
  scope :by_region, ->(region) { where(region: region) }
  scope :by_career, ->(career) { where('career_interest LIKE ? OR career_interest_2 LIKE ?', "%#{career}%", "%#{career}%") }
  scope :graduated, -> { where(graduation_status: 'Egresado') }
  scope :current_students, -> { where.not(graduation_status: 'Egresado') }
end
