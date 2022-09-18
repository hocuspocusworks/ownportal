module Api
  class StreamsController < ApplicationController
    include Api::Extensions::Resourceful

    def index
      render_json @streams, include: %i[source group]
    end

    def create
      save_form
    end

    def update
      save_form
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
