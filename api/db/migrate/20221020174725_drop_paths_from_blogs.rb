class DropPathsFromBlogs < ActiveRecord::Migration[7.0]
  def change
    remove_column :blogs, :html_path, :string
    remove_column :blogs, :rss_path, :string
  end
end
