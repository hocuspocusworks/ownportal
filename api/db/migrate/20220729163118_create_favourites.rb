# :string, :text, :integer, :float, :decimal, :datetime, :timestamp, :time, :date, :binary, :boolean
class CreateFavourites < ActiveRecord::Migration[7.0]
  def change
    create_table :favourites do |t|
      t.string :description
      t.string :link
      t.datetime :published_date
      t.string :publisher
      t.string :title

      t.belongs_to :user, index: true, foreign_key: true

      t.timestamps
    end
  end
end
