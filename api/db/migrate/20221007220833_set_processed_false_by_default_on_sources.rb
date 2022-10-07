class SetProcessedFalseByDefaultOnSources < ActiveRecord::Migration[7.0]
  def change
    change_column_default :sources, :processed, false
  end
end
