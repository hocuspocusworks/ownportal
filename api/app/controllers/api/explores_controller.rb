require 'uri'

module Api
  class ExploresController < ApplicationController
    skip_before_action :authenticate, only: :search

    # save source to db
    def create
      nil
    end

    def search
      result = if valid_url?
                 Source.with_url(keyword)
               else
                 Source.with_keyword(keyword)
               end
      render_json result
    end

    private

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
