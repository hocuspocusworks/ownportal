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

    def destroy
      @favourite.destroy
    end

    private

    def load_resource
      @favourite ||= resource_scope.find_by(id: params[:id])
    end

    def load_collection
      @favourites ||= resource_scope.order(published_date: :desc)
    end

    def policy_class
      FavouritePolicy
    end
  end
end
