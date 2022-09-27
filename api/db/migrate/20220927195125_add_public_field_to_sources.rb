class AddPublicFieldToSources < ActiveRecord::Migration[7.0]
  def change
    add_column :sources, :public, :boolean
  end
end
