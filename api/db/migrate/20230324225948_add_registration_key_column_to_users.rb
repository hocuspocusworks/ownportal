class AddRegistrationKeyColumnToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :registration_key, :string, unique: true
    add_column :users, :registration_key_activated_on, :date
  end
end
