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
      render_json Api::Services::RssFinder.new(params[:url], current_user).call
    end

    def top
      render_json top_category_results
    end

    private

    def top_category_results
      Source.where("categories ?| ARRAY[:query]", query: categories).limit(100)
    end

    def search_by_keyword
      return Source.with_keyword(keyword).with_safe if true?(safe)

      Source.with_keyword(keyword).with_allowed
    end

    def categories
      user_params[:categories].split(',')
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

    def user_params
      params.permit([:keyword, :safe, :categories])
    end

    def true?(value)
      ActiveModel::Type::Boolean.new.cast(value) == true
    end
  end
end
