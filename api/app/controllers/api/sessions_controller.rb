module Api
  class SessionsController < ApplicationController
    include Api::Extensions::Respondable

    skip_before_action :authenticate

    def create
      user = User.find_by(email: params[:session][:email])

      if user.present? && user.authenticate(params[:session][:password])
        render_json user
      else
        render json: { errors: { credentials: ['are invalid'] } },
               status: :unauthorized
      end
    end

    def destroy
      token = request.headers['Authorization']
      user = User.find_by(token: token)
      user.regenerate_token
    end
  end
end
