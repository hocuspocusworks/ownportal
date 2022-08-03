class AddUniqueIndexToSourcesUrl < ActiveRecord::Migration[7.0]
  def change
    add_index :sources, :url, unique: true
  end
end
