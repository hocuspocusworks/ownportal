class AddCompositeIndexToGroup < ActiveRecord::Migration[7.0]
  def change
    add_index :groups, %w[name user_id], unique: true
  end
end
