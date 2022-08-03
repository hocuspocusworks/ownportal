require 'uri'

module Api
  class ExploresController < ApplicationController
    skip_before_action :authenticate, only: :search

    # save source to db
    def create
      nil
    end

    def search
      url = url_from_param
      return unless Source.with_url(url).empty?
    end

    private

    def url_from_param
      valid_url || raise_error
    end

    def valid_url
      user_params[:keyword] =~ URI::DEFAULT_PARSER.make_regexp ? user_params[:keyword] : false
    end

    def raise_error
      # raise some error
    end

    def user_params
      params.permit(:keyword)
    end
  end
end
