class ChangeColumnDescriptionIncreaseLimitInSources < ActiveRecord::Migration[7.0]
  def change
    change_column :sources, :description, :string, limit: 512
  end
end
