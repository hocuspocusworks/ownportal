module Api
  class SourcesController < ApplicationController
    include Api::Extensions::Resourceful

    def index
      render json: Source.first(20)
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

    def user_params
      params.require(:source).permit(policy(Source).permitted_attributes)
    end
  end
end
