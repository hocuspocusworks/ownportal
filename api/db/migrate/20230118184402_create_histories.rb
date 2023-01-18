class CreateHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :histories do |t|
      t.belongs_to  :article, index: true
      t.belongs_to  :user, index: true
      t.boolean     :stale, index: true

      t.timestamps
    end
  end
end
