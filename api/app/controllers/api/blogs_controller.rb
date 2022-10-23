module Api
  class BlogsController < ApplicationController
    include Api::Extensions::Resourceful

    def index
      render_json @blogs
    end

    def create
      save_form
    end

    def update
      save_form
    end

    def destroy
      @space.destroy
      head :no_content
    end

    private

    def policy_class
      BlogPolicy
    end

    def load_resource
      @space ||= Blog.find(params[:id])
    end

    def load_collection
      @blogs ||= resource_scope
    end
  end
end
