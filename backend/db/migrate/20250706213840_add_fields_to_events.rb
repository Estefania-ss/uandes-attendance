class AddFieldsToEvents < ActiveRecord::Migration[8.0]
  def change
    add_column :events, :campaign_id, :string
  end
end
