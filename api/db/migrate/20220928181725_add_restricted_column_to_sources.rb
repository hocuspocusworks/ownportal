class AddRestrictedColumnToSources < ActiveRecord::Migration[7.0]
  def change
    add_column :sources, :restricted, :boolean, null: false, default: true
  end
end
