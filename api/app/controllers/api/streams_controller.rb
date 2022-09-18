module Api
  class StreamsController < ApplicationController
    include Api::Extensions::Resourceful

    def index
      render_json @streams, include: %i[source group]
    end

    def create
      if @stream.save
        render @stream, status: :created
      else
        render json: { errors: @stream.errors }, status: :bad_request
      end
    end

    def update
      if @stream.update(permit_params)
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

    def load_collection
      @streams ||= top_streams
    end

    def top_streams
      Stream.first(20)
    end
  end
end
