module Api
  class HistoriesController < ApplicationController
    include Api::Extensions::Resourceful

    def index
      render_json @histories, include: :article
    end

    def count
      render_json History.where(user: current_user)
                         .where('stale = FALSE OR stale IS NULL')
                         .count
    end

    def read
      resource_scope.where('stale = FALSE OR stale IS NULL')
                    .update_all('stale = true')
    end

    def show; end

    def create
      AddToHistoryJob.perform_later(@history.article_id, @history.user_id)

      head :no_content
    end

    def update; end

    def destroy; end

    private

    def load_resource
      @history = History.find(params[:id])
    end

    def load_collection
      @histories ||=
        History.includes(:article)
               .where(user: current_user)
               .order(created_at: :desc)
    end
  end
end
