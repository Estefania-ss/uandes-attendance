class AddFieldsToApplicants < ActiveRecord::Migration[8.0]
  def change
    add_column :applicants, :candidate_id, :string
    add_column :applicants, :last_name, :string
    add_column :applicants, :graduation_year, :string
    add_column :applicants, :graduation_status, :string
    add_column :applicants, :phone, :string
    add_column :applicants, :career_interest_2, :string
    add_column :applicants, :region, :string
  end
end
