class RoomAssignment < ApplicationRecord
  belongs_to :applicant
  belongs_to :room
  belongs_to :event
end
