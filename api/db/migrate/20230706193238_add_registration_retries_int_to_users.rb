class AddRegistrationRetriesIntToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :registration_retries, :integer, default: 0, null: false
  end
end
