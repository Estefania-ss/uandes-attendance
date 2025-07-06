class CreateApplicants < ActiveRecord::Migration[8.0]
  def change
    create_table :applicants do |t|
      t.string :name
      t.string :rut
      t.string :school
      t.string :comuna
      t.string :career_interest
      t.string :email

      t.timestamps
    end
  end
end
