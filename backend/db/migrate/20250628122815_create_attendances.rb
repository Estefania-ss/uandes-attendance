class CreateAttendances < ActiveRecord::Migration[8.0]
  def change
    create_table :attendances do |t|
      t.references :applicant, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true
      t.string :status

      t.timestamps
    end
  end
end
