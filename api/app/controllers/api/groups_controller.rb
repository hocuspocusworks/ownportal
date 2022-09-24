module Api
  class GroupsController < ApplicationController
    include Api::Extensions::Resourceful

    def index
      render_json @groups, include: %i[user streams sources]
    end

    def create
      save_form
    end

    def update
      save_form
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
