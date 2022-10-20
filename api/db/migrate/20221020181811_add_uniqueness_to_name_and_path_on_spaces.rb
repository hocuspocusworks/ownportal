class AddUniquenessToNameAndPathOnSpaces < ActiveRecord::Migration[7.0]
  def change
    add_index :spaces, :name, unique: true
    add_index :spaces, :path, unique: true
  end
end
