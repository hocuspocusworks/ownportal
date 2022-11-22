class AddSubscriptionEndDateToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :subscription_end_date, :date
  end
end
