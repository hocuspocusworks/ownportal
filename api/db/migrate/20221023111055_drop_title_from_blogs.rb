class DropTitleFromBlogs < ActiveRecord::Migration[7.0]
  def change
    remove_column :blogs, :title, :string
  end
end
