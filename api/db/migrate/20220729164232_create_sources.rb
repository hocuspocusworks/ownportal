class CreateSources < ActiveRecord::Migration[7.0]
  def change
    create_table :sources do |t|
      t.string :description
      t.string :icon
      t.string :language
      t.string :name
      t.datetime :timestamp
      t.string :url

      t.timestamps
    end
  end
end
