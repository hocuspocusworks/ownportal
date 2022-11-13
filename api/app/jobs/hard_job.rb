class HardJob < ApplicationJob
  def perform
    Tag.create(name: 'bla', colour: 'red', user_id: 3)
  end
end
