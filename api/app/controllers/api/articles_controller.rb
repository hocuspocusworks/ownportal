module Api
  class ArticlesController < ApplicationController
    include Api::Extensions::Resourceful
    include Api::Extensions::Paginable

    def index
      render_json @articles
    end

    def load_collection
      @articles ||= paginate(articles_sql)
    end

    private

    def articles_sql
      raise 'No source_ids provided' if source_ids.blank?

      Article.where(source_id: source_ids).order(published_date: :desc)
    end

    def source_ids
      return [] unless user_params[:source] || user_params[:group]

      user_params[:source] ? [user_params[:source].to_i] : group_source_ids(user_params[:group])
    end

    def group_source_ids(group_id)
      Group.joins(:sources).where(id: group_id).pluck(:source_id)
    end
  end
end
