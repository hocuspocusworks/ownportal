class ApplicationController < ActionController::API
  include Pundit::Authorization
  include Api::Extensions::Authentication

  before_action :authenticate
  before_action :load_resource, only: %i[show update destroy]

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    render json: { 'errors': { 'token': ['is invalid'] } }, status: :forbidden
  end
end
