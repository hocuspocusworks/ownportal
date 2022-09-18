class AddTagsTable < ActiveRecord::Migration[7.0]
  def change
    create_table :tags do |t|
      t.string :name
      t.string :colour

      t.references :user

      t.timestamps
    end
  end
end
