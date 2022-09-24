class AddJsonTagsToFavourites < ActiveRecord::Migration[7.0]
  def change
    add_column :favourites, :tags_json, :jsonb
  end
end
