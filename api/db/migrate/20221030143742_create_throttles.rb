class CreateThrottles < ActiveRecord::Migration[7.0]
  def change
    create_table :throttles do |t|
      t.integer :count
      t.string  :remote_ip
      t.integer :user_id, null: true

      t.timestamps
    end
  end
end
