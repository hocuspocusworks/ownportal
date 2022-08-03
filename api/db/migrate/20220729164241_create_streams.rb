class CreateStreams < ActiveRecord::Migration[7.0]
  def change
    create_table :streams do |t|
      t.string :name

      t.belongs_to :group, index: true, foreign_key: true
      t.belongs_to :source, index: true, foreign_key: true

      t.timestamps
    end
  end
end
