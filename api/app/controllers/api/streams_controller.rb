module Api
  class StreamsController < ApplicationController
    def index
      render json: StreamSerializer.render(Stream.first(20), root: :streams), status: :ok
    end

    def create
      group = Group.with_name(params[:group], current_user).ids[0]
      source = Source.with_url(params[:url]).ids[0]
      stream = Stream.new(name: params[:stream], group_id: group, source_id: source)

      if stream.save
        render json: StreamSerializer.render(stream), status: :created
      else
        render json: { errors: stream.errors }, status: :bad_request
      end
    end

    def update
      authorize Stream

      if @stream.update(user_params)
        render json: UserSerializer.render(@stream), status: :ok
      else
        render json: { errors: @stream.errors }, status: :bad_request
      end
    end

    def destroy
      authorize Stream.joins(:group).where('streams.id = ?', params[:id])

      @stream.destroy
      render json: {}, status: :no_content
    end

    private

    def load_resource
      @stream ||= Stream.find(params[:id])
    end

    def user_params
      params.require(:stream).permit(policy(Stream).permitted_attributes)
    end
  end
end
