class RenamePublicFieldToPublishedInSources < ActiveRecord::Migration[7.0]
  def change
    rename_column :sources, :public, :published
  end
end
