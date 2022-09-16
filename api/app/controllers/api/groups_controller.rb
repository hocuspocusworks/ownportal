module Api
  class GroupsController < ApplicationController
    include Api::Extensions::Resourceful

    def index
      render_json @groups
    end

    def create
      if @group.save
        render_json @group, status: :created
      else
        render json: { errors: @group.errors }, status: :bad_request
      end
    end

    def update
      if @group.update(user_params)
        render_json @group
      else
        render json: { errors: @group.errors }, status: :bad_request
      end
    end

    def destroy
      @group.destroy
      render json: {}, status: :no_content
    end

    private

    def load_resource
      @group ||= Group.find(params[:id])
    end

    def load_collection
      @groups ||= GroupsQueries.new.with_streams(current_user.id)
    end

    def user_params
      params.require(:group).permit(policy(Group).permitted_attributes)
    end
  end
end
