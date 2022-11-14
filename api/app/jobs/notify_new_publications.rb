class NotifyNewPublications < ApplicationJob
  def perform
    User.where(paid: true).each do |user|
      puts user.email
    end
  end
end
