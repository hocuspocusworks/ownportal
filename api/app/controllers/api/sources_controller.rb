module Api
  class SourcesController < ApplicationController
    def index
      render json: Source.first(20)
    end

    def create
      source = Source.create(user_params)

      if source.save
        render json: source, status: :created
      else
        render json: { errors: source.errors }, status: :bad_request
      end
    end

    def update
      authorize Source

      if @source.update(user_params)
        render json: @source, status: :ok
      else
        render json: { errors: @source.errors }, status: :bad_request
      end
    end

    def destroy
      authorize Source

      @source.destroy
      render json: {}, status: :no_content
    end

    private

    def load_resource
      @source ||= Source.find(params[:id])
    end

    def user_params
      params.require(:source).permit(policy(Source).permitted_attributes)
    end
  end
end
