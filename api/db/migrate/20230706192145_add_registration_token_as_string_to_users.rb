class AddRegistrationTokenAsStringToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :registration_token, :string
    add_column :users, :registration_email_last_sent, :datetime
    add_column :users, :registration_confirmed, :boolean, default: false, null: false
  end
end
