class SetRestrictedDefaultVisibilityForSources < ActiveRecord::Migration[7.0]
  def change
    change_column_default :sources, :visibility, 1
  end
end
