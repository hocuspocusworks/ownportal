class AddMediaUrlToArticles < ActiveRecord::Migration[7.0]
  def change
    add_column :articles, :media_url, :string
  end
end
