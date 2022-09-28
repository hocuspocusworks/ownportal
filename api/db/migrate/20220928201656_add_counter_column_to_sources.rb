class AddCounterColumnToSources < ActiveRecord::Migration[7.0]
  def change
    add_column :sources, :counter, :integer, index: true
  end
end
