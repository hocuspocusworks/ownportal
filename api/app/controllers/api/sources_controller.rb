module Api
  class SourcesController < ApplicationController
    include Api::Extensions::Resourceful
    include Api::Extensions::Respondable

    def index
      render_json @sources
    end

    def create
      save_form
    end

    private

    def policy_class
      SourcePolicy
    end

    def load_resource
      @source ||= Source.find(params[:id])
    end

    def load_collection
      @sources ||= resource_scope
    end

    def user_params
      params.require(:source).permit(policy(Source).permitted_attributes)
    end
  end
end
