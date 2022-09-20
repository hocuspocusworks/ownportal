module Api
  class SessionsController < ApplicationController
    include Api::Extensions::Respondable
    include Api::Extensions::Resourceful

    skip_before_action :authenticate

    def create
      authorize nil, policy_class: SessionPolicy
      user = User.find_by(email: params[:session][:email])

      if user.present? && user.authenticate(params[:session][:password])
        render_json user
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
