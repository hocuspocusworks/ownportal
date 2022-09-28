class CreateStats < ActiveRecord::Migration[7.0]
  def change
    create_view :stats
  end
end
