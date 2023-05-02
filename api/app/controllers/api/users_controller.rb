module Api
  class UsersController < ApplicationController
    include Api::Extensions::Resourceful

    skip_before_action :authenticate, only: :create
    skip_before_action :authorise_resource, only: :create
    skip_before_action :resource_from_attributes, only: :create
    skip_after_action :verify_authorized, only: :create
    skip_before_action :load_collection, only: :index

    def index
      user = current_user.as_json
      user['settings'] = JSON.parse(current_user['settings'])
      render_json user
    end

    def all_users
      render_json policy_scope(User)
    end

    def show
      user = @user.as_json
      user['settings'] = JSON.parse(user['settings'])
      render_json user
    end

    def create
      return if form_token_invalid?

      render json: user_limit_error, status: :forbidden and return if user_limit_reached?

      user = User.create(create_permitted_attributes.merge(default_settings))
      if user.errors.empty?
        render_json user, status: :created
      else
        render json: { errors: { user: [user.errors] } }, status: :forbidden
      end
    end

    def update
      save_form
    end

    def destroy
      DestroyUser.perform_later(@user.id)
      render json: {}, status: :no_content
    end

    private

    def load_resource
      @user ||= User.find(params[:id])
    end

    def policy_class
      UserPolicy
    end

    # only for create, we don't want to go through pundit when a user doesn't exist
    def create_permitted_attributes
      params.permit(user: [:email, :password]).to_h[:user]
    end

    def default_settings
      { settings: [:dark], sysadmin: false }
    end

    def user_limit_error
      { errors: { user: ['registration limit reached'] } }
    end

    def user_limit_reached?
      true if user_count > registration_limit
    end

    def user_count
      Rails.cache.fetch('user_count', expires_in: 1.minute) { User.all.count }
    end

    def registration_limit
      Rails.cache.fetch('registration_limit') { 100 }
    end

    def form_token_invalid?
      params.permit(user: [:form_token]).to_h[:user][:form_token].present?
    end
  end
end
