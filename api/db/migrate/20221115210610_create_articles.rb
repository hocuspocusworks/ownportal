class CreateArticles < ActiveRecord::Migration[7.0]
  def change
    create_table :articles do |t|
      t.string    :description
      t.string    :link
      t.datetime  :published_date
      t.string    :publisher
      t.string    :title
      t.boolean   :stale, index: true

      t.belongs_to :source, index: true
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
