class AddCreatorColumnToSources < ActiveRecord::Migration[7.0]
  def change
    add_reference :sources, :creator, index: true
  end
end
