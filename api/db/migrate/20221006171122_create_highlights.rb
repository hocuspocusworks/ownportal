class CreateHighlights < ActiveRecord::Migration[7.0]
  def change
    create_table :highlights do |t|
      t.string :keyword
      t.string :colour
      t.references :user

      t.timestamps
    end
  end
end
