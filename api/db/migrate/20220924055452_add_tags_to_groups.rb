class AddTagsToGroups < ActiveRecord::Migration[7.0]
  def change
    add_column :groups, :tags, :json
  end
end
