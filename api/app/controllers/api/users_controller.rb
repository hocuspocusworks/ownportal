module Api
  class UsersController < ApplicationController
    skip_before_action :authenticate, only: :create

    def index
      authorize User

      render_json User.all
    end

    def create
      authorize User
      user = User.create(user_params)

      if user.save
        render json: user, status: :created
      else
        render json: { errors: user.errors }, status: :bad_request
      end
    end

    def update
      authorize @user

      if @user.update(user_params)
        render json: @user, status: :ok
      else
        render json: { errors: @user.errors }, status: :bad_request
      end
    end

    def destroy
      authorize @user

      @user.destroy
      render json: {}, status: :no_content
    end

    private

    def load_resource
      @user ||= User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(policy(User).permitted_attributes)
    end
  end
end