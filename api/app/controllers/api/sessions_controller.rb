module Api
  class SessionsController < ApplicationController
    include Api::Extensions::Respondable
    include Api::Extensions::Resourceful

    skip_before_action :authenticate, only: [:create]
    skip_before_action :authorise_resource, only: [:create]
    skip_before_action :resource_from_attributes, only: [:create]
    skip_after_action :verify_authorized, only: [:create]

    def create
      user = User.find_by(email: params[:session][:email])

      if user_valid?(user)
        user_token = { 'session': { 'token': encode_jwt(user), 'sysadmin': user.sysadmin, 'id': user.id } }
        render_json user_token, status: 201
      else
        render json: { errors: { credentials: ['are invalid'] } },
               status: :unauthorized
      end
    end

    def destroy
      @session&.regenerate_token
    end

    private

    def load_resource
      @session ||= current_user
    end

    def policy_class
      SessionPolicy
    end

    def user_valid?(user)
      user.present? && user.deactivated_at.nil? && user.authenticate(params[:session][:password])
    end
  end
end
