class CreateSpaces < ActiveRecord::Migration[7.0]
  def change
    create_table :spaces do |t|
      t.string :name, null: false
      t.string :description
      t.string :path, null: false

      t.timestamps
    end
  end
end
