module Api
  class SpacesController < ApplicationController
    include Api::Extensions::Resourceful

    def index
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
      @space ||= Space.find(params[:id])
    end
  end
end
