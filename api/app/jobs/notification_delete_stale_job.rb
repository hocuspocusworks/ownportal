class NotificationDeleteStaleJob < ApplicationJob
  def perform
    Notification.where(stale: true).in_batches(of: 100).delete_all
  end
end
