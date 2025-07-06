class AddPredictionAndCheckinToAttendances < ActiveRecord::Migration[8.0]
  def change
    add_column :attendances, :predicted_status, :string
    add_column :attendances, :real_status, :string
    add_column :attendances, :checked_in_at, :datetime
  end
end
