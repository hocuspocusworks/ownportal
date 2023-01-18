class AddUniqueIndexToHistory < ActiveRecord::Migration[7.0]
  def change
    add_index :histories, [:article_id, :user_id], unique: true
  end
end
