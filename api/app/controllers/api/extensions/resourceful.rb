module Api
  module Extensions
    module Resourceful
      extend ActiveSupport::Concern

      included do
        before_action :authorise_resource
        before_action :load_collection, only: [:index]
        before_action :resource_from_attributes, only: %i[create update]
      end

      private

      def save_form(opts = {})
        if resource_item.save
          render_json resource_item, response_opts(opts)
        else
          render json: { errors: resource_item.errors }, status: :bad_request
        end
      end

      def response_opts(opts)
        status_code = action_name == 'create' ? 201 : 200
        opts.merge({ status: status_code })
      end

      def authorise_resource
        authorize(resource_item || resource_class, policy_class: policy_class)
      end

      def resource_item
        instance_variable_get("@#{controller_name.singularize}")
      end

      def resource_class
        controller_name.classify.constantize
      end

      def resource_scope
        policy_scope(resource_class, policy_scope_class: policy_scope_class)
      end

      def policy_scope_class
        return unless policy_class

        "#{policy_class.name}::Scope".constantize
      end

      def resource_from_attributes
        instance_variable_set(resource_variable, params_to_object)
      end

      def params_to_object
        "#{resource_class}Deserialiser".constantize.deserialise(resource_item, permit_params, current_user)
      end

      def permit_params
        params.require(resource_name.to_sym).permit(policy(resource_class).permitted_attributes)
      end

      def policy_class; end

      def policy_identifier
        policy_class.to_s.downcase.to_sym
      end

      def resource_policy
        policy_class&.new(current_user, resource_item) || policy(resource_item)
      end

      def resource_name
        controller_name.singularize.downcase
      end

      def resource_variable
        "@#{resource_name}"
      end
    end
  end
end
