module Api
  module Admin
    class StatsController < ApplicationController
      include Api::Extensions::Resourceful

      def index
        render_json @stats
      end

      def load_collection
        @stats ||= resource_scope
      end

      def policy_class
        StatPolicy
      end
    end
  end
end
