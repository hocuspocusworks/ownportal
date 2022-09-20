module Api
  class UsersController < ApplicationController
    include Api::Extensions::Resourceful

    skip_before_action :authenticate, only: :create

    def index
      authorize User

      render_json User.all
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

    def user_params
      params.require(:user).permit(policy(User).permitted_attributes)
    end
  end
end
