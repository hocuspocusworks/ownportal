module Api
  class ArticlesController < ApplicationController
    include Api::Extensions::Resourceful

    def index
      render_json @articles
    end

    def load_collection
      @articles ||=
        Article.where(source_id: user_params[:sources])
               .order(published_date: :desc)
               .limit(50)
    end

    def user_params
      params.permit(policy(resource_class).permitted_attributes)
    end
  end
end