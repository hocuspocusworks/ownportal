module Api
  class GroupsController < ApplicationController
    def index
      # refactor - should be a special serialiser. group one should be simple so other ops work
      authorize Group
      render json: GroupSerializer.render(GroupsQueries.new.with_streams(current_user.id), root: :groups),
             status: :ok
    end

    def create
      group = Group.new(user_params)
      group.user_id = current_user.id
      authorize group

      if group.save
        render json: GroupSerializer.render(group), status: :created
      else
        render json: { errors: group.errors }, status: :bad_request
      end
    end

    def update
      authorize @group

      if @group.update(user_params)
        render json: GroupSerializer.render(@group), status: :ok
      else
        render json: { errors: @group.errors }, status: :bad_request
      end
    end

    def destroy
      authorize @group

      @group.destroy
      render json: {}, status: :no_content
    end

    private

    def load_resource
      @group ||= Group.find(params[:id])
    end

    def user_params
      params.require(:group).permit(policy(Group).permitted_attributes)
    end
  end
end
