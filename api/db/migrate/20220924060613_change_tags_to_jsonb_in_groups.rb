class ChangeTagsToJsonbInGroups < ActiveRecord::Migration[7.0]
  def up
    change_column :groups, :tags, :jsonb
  end

  def down
    change_column :groups, :tags, :json
  end
end
