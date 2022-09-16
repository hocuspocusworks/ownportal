module Api
  class StreamsController < ApplicationController
    include Api::Extensions::Resourceful

    def index
      render_json Stream.first(20)
    end

    def create
      stream_obj = stream.save

      if stream_obj
        render_json stream_obj, status: :created
      else
        render json: { errors: stream.errors }, status: :bad_request
      end
    end

    def update
      if @stream.update(user_params)
        render_json @stream
      else
        render json: { errors: @stream.errors }, status: :bad_request
      end
    end

    def destroy
      @stream.destroy
      render json: {}, status: :no_content
    end

    private

    def policy_class
      StreamPolicy
    end

    def load_resource
      @stream ||= Stream.find(params[:id])
    end

    def user_params
      params.require(:stream).permit(policy(Stream).permitted_attributes)
    end
  end
end
