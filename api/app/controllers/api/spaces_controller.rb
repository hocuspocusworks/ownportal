module Api
  class SpacesController < ApplicationController
    include Api::Extensions::Resourceful

    def index
    end

    def show
      if @space
        render_json @space
      else
        head :not_found
      end
    end

    def create
      save_form
    end

    def update
      save_form
    end

    def destroy
    end

    private

    def policy_class
      SpacePolicy
    end

    def load_resource
      @space ||= Space.find_by(user_id: user_params[:id])
    end

    def user_params
      params.permit([:id])
    end
  end
end
