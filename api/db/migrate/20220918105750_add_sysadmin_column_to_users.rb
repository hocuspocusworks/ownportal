class AddSysadminColumnToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :sysadmin, :boolean
  end
end
