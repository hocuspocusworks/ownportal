class AddCategoriesToSources < ActiveRecord::Migration[7.0]
  def change
    add_column :sources, :categories, :jsonb
  end
end
