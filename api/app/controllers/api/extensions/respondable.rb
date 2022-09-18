module Api
  module Extensions
    module Respondable
      extend ActiveSupport::Concern

      private

      def render_json(resource, opts = {})
        # handle status in opts
        render json: resource.to_json(opts)
      end
    end
  end
end
