module Api
  class UsersController < ApplicationController
    include Api::Extensions::Resourceful

    skip_before_action :authenticate, only: :create
    skip_before_action :authorise_resource, only: :create
    skip_before_action :resource_from_attributes, only: :create
    skip_after_action :verify_authorized, only: :create
    skip_before_action :load_collection, only: :index

    def index
      render_json current_user
    end

    def all_users
      render_json policy_scope(User)
    end

    def show
      render_json @user
    end

    def create
      user = User.create(user_params.merge(default_settings))
      if user.errors.empty?
        render_json user, status: :created
      else
        render json: { 'errors': { 'user': [user.errors] } }, status: :forbidden
      end
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

    def user_params
      params.require(:user).permit([:email, :password])
    end

    def default_settings
      { settings: [:safe], sysadmin: false }
    end
  end
end
