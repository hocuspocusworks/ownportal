class ChangeRegistrationConfirmedToDateTimeInUsers < ActiveRecord::Migration[7.0]
  def change
    change_column :users, :registration_confirmed, :datetime, null: true
  end
end
