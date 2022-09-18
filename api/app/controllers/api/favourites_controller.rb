module Api
  class FavouritesController < ApplicationController
    include Api::Extensions::Resourceful

    def index
      render_json @favourites, include: { taggings: { include: :tag } }
    end

    def create
      if @favourite.save
        render_json @favourite
      else
        render json: { errors: @favourite.errors }, status: :bad_request
      end
    end

    def update
      if @favourite.save
        render_json @favourite
      else
        render json: { errors: @favourite.errors }, status: :bad_request
      end
    end

    def destroy
    end

    private

    def load_resource
      @favourite ||= resource_scope.find_by(id: params[:id])
    end

    def load_collection
      @favourites ||= resource_scope
    end

    def policy_class
    end

    def user_params
      params.require(:favourite).permit(policy(Favourite).permitted_attributes)
    end
  end
end
