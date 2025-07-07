class Event < ApplicationRecord
  has_many :attendances, dependent: :destroy
  has_many :applicants, through: :attendances
  has_many :rooms, dependent: :destroy
  has_many :room_assignments, dependent: :destroy

  validates :name, presence: true
  validates :date, presence: true
  validates :event_type, presence: true
  validates :campaign_id, uniqueness: true, allow_blank: true

  # Métodos helper
  def total_applicants
    applicants.count
  end

  def confirmed_attendances
    attendances.where(status: "confirmado").count
  end

  def attendance_rate
    return 999 if date >= Date.current # Evento futuro: predicción
    return 0 if total_applicants.zero?
    real_confirmed = attendances.where(real_status: "confirmado").count
    (real_confirmed.to_f / total_applicants * 100).round(2)
  end

  def schools
    applicants.where.not(school: [ nil, "" ]).distinct.pluck(:school)
  end

  def careers
    applicants
      .pluck(:career_interest, :career_interest_2)
      .flatten
      .compact
      .reject(&:blank?)
      .uniq
  end
end
