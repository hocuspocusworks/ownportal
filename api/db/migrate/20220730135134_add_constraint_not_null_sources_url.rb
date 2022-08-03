class AddConstraintNotNullSourcesUrl < ActiveRecord::Migration[7.0]
  def change
    change_column_null :sources, :url, false
    change_column_null :sources, :name, false
  end
end
