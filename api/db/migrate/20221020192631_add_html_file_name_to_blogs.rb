class AddHtmlFileNameToBlogs < ActiveRecord::Migration[7.0]
  def change
    add_column :blogs, :html_file_name, :string

    add_index :blogs, [:user_id, :html_file_name], unique: true
  end
end
