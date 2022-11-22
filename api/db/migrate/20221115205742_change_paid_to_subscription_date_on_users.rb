class ChangePaidToSubscriptionDateOnUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :paid, :boolean
    add_column :users, :subscription_date, :date
  end
end
