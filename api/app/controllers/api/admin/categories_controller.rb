module Api
  module Admin
    class CategoriesController < ApplicationController
      include Api::Extensions::Resourceful

      def index
        render_json @categories
      end

      def create
        save_form
      end

      def update
        save_form
      end

      def destroy
        @category.destroy
      end

      private

      def load_resource
        @category ||= resource_scope.find_by(id: params[:id])
      end

      def load_collection
        @categories ||= resource_scope
      end

      def policy_class
        CategoryPolicy
      end

      def user_params
        params.require(:category).permit(policy(Category).permitted_attributes)
      end
    end
  end
end
