class AddUniqueIndexForStreams < ActiveRecord::Migration[7.0]
  def change
    add_index :streams, %w[name group_id source_id], unique: true
  end
end
