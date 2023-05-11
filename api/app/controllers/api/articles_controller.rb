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
      raise 'No source or group provided' if source_id.blank? && group_id.blank?

      source_id.present? ? source_article_ids : group_article_ids
    end

    def source_article_ids
      Articles::SourceLoader.new(source_id).call
    end

    def group_article_ids
      Articles::GroupLoader.new(group_id).call
    end

    def source_id
      @source_id ||= user_params[:source]
    end

    def group_id
      @group_id ||= user_params[:group]
    end
  end
end
