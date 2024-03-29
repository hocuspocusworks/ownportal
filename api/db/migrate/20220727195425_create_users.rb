class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :email, null: false, index: { unique: true, name: 'unique_emails' }
      t.string :password_digest
      t.string :token
      t.string :role

      t.timestamps
    end
  end
end
