class CreateRoomAssignments < ActiveRecord::Migration[8.0]
  def change
    create_table :room_assignments do |t|
      t.references :applicant, null: false, foreign_key: true
      t.references :room, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true

      t.timestamps
    end
  end
end
