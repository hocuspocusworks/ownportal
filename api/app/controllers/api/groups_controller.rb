module Api
  class GroupsController < ApplicationController
    include Api::Extensions::Resourceful

    def index
      render_json @groups, include: [:user, :streams, :sources]
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
      @groups ||= Group
                  .includes(:streams)
                  .includes(:sources)
                  .where(groups: { user: current_user })
                  .where(sources: { visibility: visibility })
    end

    def user_params
      params.require(:group).permit(policy(Group).permitted_attributes)
    end

    def visibility
      return [2, nil] if current_user.safe_search?

      [1, 2, nil]
    end
  end
end
