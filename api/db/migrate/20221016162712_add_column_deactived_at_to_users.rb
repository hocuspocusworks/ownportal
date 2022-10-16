class AddColumnDeactivedAtToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :deactivated_at, :datetime, default: nil
    add_index :users, :deactivated_at
  end
end
