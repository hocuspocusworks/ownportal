module Api
  class BlogsController < ApplicationController
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
      BlogPolicy
    end

    def load_resource
      @space ||= Blog.find(params[:id])
    end
  end
end
