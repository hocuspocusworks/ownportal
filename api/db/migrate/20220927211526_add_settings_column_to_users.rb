class AddSettingsColumnToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :settings, :jsonb
  end
end
