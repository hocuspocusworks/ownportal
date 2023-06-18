require 'uri'

module Api
  class ExploresController < ApplicationController
    include Api::Extensions::Resourceful

    # save source to db
    def create
      nil
    end

    def search
      render_json search_by_keyword
    end

    def rss
      rss = Api::Services::RssFinder.new(user_params[:url], current_user).call

      head :no_content, status: :no_content and return unless rss

      FetchFeedJob.perform_later(rss.id)
      render_json rss
    end

    def top
      render_json top_category_results
    end

    private

    def top_category_results
      Source
        .where(categories_sql)
        .where(published: true)
        .where(visibility: Source.visibilities[:safe])
        .order(updated_at: :desc)
        .limit(100)
        .as_json
        .map do |record|
          next if record['categories'].blank?

          record['categories'] = JSON.parse(record['categories'])
          record
        end
    end

    def search_by_keyword
      return Source.with_keyword(keyword).with_safe if true?(safe)

      Source.with_keyword(keyword).with_allowed
    end

    def categories
      user_params[:categories].split(',')
    end

    def categories_sql
      categories = user_params[:categories].split(',')

      return if categories.blank? || categories.size > 5

      [].tap do |list|
        categories.each do |category|
          list << "(categories LIKE '%#{category}%')"
        end
      end.join(' OR ')
    end

    def safe
      @safe ||= user_params[:safe]
    end

    def keyword
      @keyword ||= user_params[:keyword]
    end

    def valid_url?
      keyword =~ URI::DEFAULT_PARSER.make_regexp ? keyword : false
    end

    def true?(value)
      ActiveModel::Type::Boolean.new.cast(value) == true
    end
  end
end
