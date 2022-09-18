require 'uri'

module Api
  class ExploresController < ApplicationController
    skip_before_action :authenticate, only: :search

    # save source to db
    def create
      nil
    end

    def search
      render_json valid_url? ? search_by_url : search_by_keyword
    end

    private

    def search_by_url
      Source.with_url(keyword)
    end

    def search_by_keyword
      Source.with_keyword(keyword)
    end

    def keyword
      @keyword ||= user_params[:keyword]
    end

    def valid_url?
      keyword =~ URI::DEFAULT_PARSER.make_regexp ? keyword : false
    end

    def user_params
      params.permit(:keyword)
    end
  end
end
