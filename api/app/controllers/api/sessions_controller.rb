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

      if user.present? && user.authenticate(params[:session][:password])
        user_token = { 'session': { 'token': encode_jwt(user) } }
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
      @session ||= User.where(token: authorisation_token).first
    end

    def policy_class
      SessionPolicy
    end
  end
end
