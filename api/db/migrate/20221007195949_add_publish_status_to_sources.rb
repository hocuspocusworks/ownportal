class AddPublishStatusToSources < ActiveRecord::Migration[7.0]
  def change
    add_column :sources, :visibility, :integer, default: 0
  end
end
