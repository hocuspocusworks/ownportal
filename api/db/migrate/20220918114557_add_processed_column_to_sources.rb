class AddProcessedColumnToSources < ActiveRecord::Migration[7.0]
  def change
    add_column :sources, :processed, :boolean
  end
end
