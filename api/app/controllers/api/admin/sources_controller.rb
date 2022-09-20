module Api
  module Admin
    class SourcesController < ApplicationController
      include Api::Extensions::Resourceful

      def index
        render_json @sources
      end

      def update
        @source.processed = true

        save_form
      end

      def destroy
        @source.destroy
      end

      private

      def load_resource
        @source ||= Source.find(params[:id])
      end

      def load_collection
        @sources ||= resource_scope
      end

      def policy_class
        ::Admin::SourcePolicy
      end

      def user_params
        params.require(:source).permit(policy(Source).permitted_attributes)
      end
    end
  end
end