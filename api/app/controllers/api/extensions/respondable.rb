module Api
  module Extensions
    module Respondable
      extend ActiveSupport::Concern

      private

      def render_json(resource, opts = {})
        response = { json: resource.to_json(opts) }
        render response.merge(render_opts(opts))
      end

      def render_opts(opts)
        result = {}
        result[:status] = opts[:status] if opts[:status]
        result
      end
    end
  end
end
