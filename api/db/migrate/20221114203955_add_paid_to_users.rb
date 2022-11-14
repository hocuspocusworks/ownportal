class AddPaidToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :paid, :boolean, default: false, null: false
  end
end
