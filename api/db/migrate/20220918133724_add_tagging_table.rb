class AddTaggingTable < ActiveRecord::Migration[7.0]
  def change
    create_table :taggings do |t|
      t.references :tag
      t.references :favourite

      t.timestamps
    end
  end
end
