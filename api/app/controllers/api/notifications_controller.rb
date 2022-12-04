module Api
  class NotificationsController < ApplicationController
    include Api::Extensions::Resourceful

    def index
      render_json @notifications, include: :article
    end

    def count
      render_json Notification.where(user: current_user)
                              .where('stale = FALSE OR stale IS NULL')
                              .count
    end

    def read
      resource_scope.where('stale = FALSE OR stale IS NULL')
                    .update_all('stale = true')
    end

    def show; end

    def create; end

    def update; end

    def destroy; end

    private

    def load_resource
      @notification = Notification.find(params[:id])
    end

    def load_collection
      @notifications ||=
        Notification.includes(:article)
                    .where(user: current_user)
                    .order(created_at: :desc)
    end
  end
end
