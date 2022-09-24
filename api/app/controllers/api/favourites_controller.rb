module Api
  class FavouritesController < ApplicationController
    include Api::Extensions::Resourceful

    def index
      render_json @favourites
    end

    def create
      save_form
    end

    def update
      save_form
    end

    def destroy; end

    private

    def load_resource
      @favourite ||= resource_scope.find_by(id: params[:id])
    end

    def load_collection
      @favourites ||= resource_scope
    end

    def policy_class
      FavouritePolicy
    end

    def user_params
      params.require(:favourite).permit(policy(Favourite).permitted_attributes)
    end
  end
end
