module Api
  module Extensions
    module Respondable
      extend ActiveSupport::Concern

      private

      def render_json(resource, opts = {})
        if resource.respond_to?(:each)
          render_collection(resource, opts)
        elsif resource.errors.blank?
          render_resource(resource, opts)
        else
          render_error(resource.errors)
        end
      end

      def render_collection(collection, opts)
        render_response(collection, opts)
      end

      def render_resource(resource, opts)
        render_response(resource, opts)
      end

      def render_response(data, opts)
        opts[:root] = controller_name
        render json: renderer.render(data, opts)
      end

      def renderer
        "#{base_name}Serializer".constantize
      end

      def base_name
        controller_name.singularize.capitalize
      end
    end
  end
end
