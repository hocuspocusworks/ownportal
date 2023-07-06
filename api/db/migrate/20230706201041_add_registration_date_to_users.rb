class AddRegistrationDateToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :registration_date, :datetime
  end
end
