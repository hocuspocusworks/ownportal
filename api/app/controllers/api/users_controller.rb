module Api
  class UsersController < ApplicationController
    include Api::Extensions::Resourceful

    skip_before_action :authenticate, only: :create
    skip_before_action :load_collection, only: :index

    def index
      render_json current_user
    end

    def show
      render_json @user
    end

    def create
      save_form
    end

    def update
      save_form
    end

    def destroy
      @user.destroy
      render json: {}, status: :no_content
    end

    private

    def load_resource
      @user ||= User.find(params[:id])
    end

    def policy_class
      UserPolicy
    end
  end
end
