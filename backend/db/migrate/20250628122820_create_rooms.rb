class CreateRooms < ActiveRecord::Migration[8.0]
  def change
    create_table :rooms do |t|
      t.string :name
      t.integer :capacity
      t.string :building
      t.references :event, null: false, foreign_key: true

      t.timestamps
    end
  end
end
