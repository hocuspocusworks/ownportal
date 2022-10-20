class AddSpaceToBlogs < ActiveRecord::Migration[7.0]
  def change
    add_reference :blogs, :space, null: false, foreign_key: true
  end
end
