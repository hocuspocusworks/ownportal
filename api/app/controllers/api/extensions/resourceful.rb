module Api
  module Extensions
    module Resourceful
      extend ActiveSupport::Concern

      included do
        before_action :authorise_resource
      end

      private

      def authorise_resource
        authorize(resource_item || resource_class, policy_class: policy_class)
      end

      def resource_item
        instance_variable_get("@#{controller_name.singularize}")
      end

      def resource_class
        controller_name.classify.constantize
      end

      def policy_class; end
    end
  end
end
