class CreateBlogs < ActiveRecord::Migration[7.0]
  def change
    create_table :blogs do |t|
      t.string :title
      t.string :language
      t.datetime :published_date
      t.string :heading
      t.text :content
      t.boolean :active
      t.string :html_path
      t.string :rss_path

      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
