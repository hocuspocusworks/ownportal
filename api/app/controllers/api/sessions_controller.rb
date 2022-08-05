module Api
  class SessionsController < ApplicationController
    skip_before_action :authenticate, :load_resource

    def create
      authorize nil, policy_class: SessionPolicy
      user = User.find_by(email: params[:session][:email])

      if user.present? && user.authenticate(params[:session][:password])
        render json: SessionSerializer.render(user, root: :session), status: :ok
      else
        render json: { errors: { credentials: ['are invalid'] } },
               status: :unauthorized
      end
    end

    def destroy
      authorize nil, policy_class: SessionPolicy
      token = request.headers['Authorization']
      user = User.find_by(token: token)
      user.regenerate_token
    end
  end
end
