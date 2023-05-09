module Api
  class ArticlesController < ApplicationController
    include Api::Extensions::Resourceful

    def index
      render_json @articles
    end

    def load_collection
      @articles ||= Article.where(id: article_ids).order(published_date: :desc)
    end

    private

    def article_ids
      raise 'No source_ids provided' if source_ids.blank?

      source_ids.size == 1 ? source_article_ids : group_article_ids
    end

    def source_article_ids
      Articles::SourceLoader.new(source_ids.first).call
    end

    def group_article_ids
      Articles::GroupLoader.new(group_id).call
    end

    def source_ids
      @source_ids ||= user_params[:sources]
    end

    def group_id
      @group_id ||= user_params[:group]
    end
  end
end
