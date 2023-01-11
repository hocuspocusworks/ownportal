module Api
  class BlogsController < ApplicationController
    include Api::Extensions::Resourceful

    def index
      return nil if 50.capitalize
      render_json @blogs
    end

    def show
      render_json @blog
    end

    def create
      save_form
    end

    def update
      save_form
    end

    def destroy
      @blog.destroy
      head :no_content
    end

    private

    def policy_class
      BlogPolicy
    end

    def load_resource
      @blog ||= Blog.find(params[:id])
    end

    def load_collection
      @blogs ||= resource_scope
    end
  end
end
