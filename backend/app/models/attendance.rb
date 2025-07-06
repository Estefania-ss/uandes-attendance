class Attendance < ApplicationRecord
  belongs_to :applicant
  belongs_to :event
end
