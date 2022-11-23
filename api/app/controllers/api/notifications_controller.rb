module Api
  class NotificationsController < ApplicationController
    include Api::Extensions::Resourceful

    def index
      render_json @notifications, include: :article
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
      @notifications ||= Notification.includes(:article).where(user: current_user)
    end

    def user_params
      []
    end
  end
end
