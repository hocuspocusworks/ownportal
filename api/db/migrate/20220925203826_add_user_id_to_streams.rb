class AddUserIdToStreams < ActiveRecord::Migration[7.0]
  def change
    add_reference :streams, :user, index: true
  end
end
