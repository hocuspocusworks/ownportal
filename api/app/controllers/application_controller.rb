class ApplicationController < ActionController::API
  include Pundit::Authorization
  include Api::Extensions::Authentication
  include Api::Extensions::Respondable

  before_action :throttle
  before_action :authenticate
  before_action :load_resource, only: %i[show update destroy]
  after_action :verify_authorized

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from Exceptions::TooManyRequests, with: :too_many_requests_error

  private

  def user_not_authorized
    render json: { 'errors': { 'token': ['is invalid'] } }, status: :forbidden
  end

  def throttle
    raise Exceptions::TooManyRequests if requests_count > requests_limit || ip_lock?

    next_request_count
  end

  def next_request_count
    Rails.cache.write(request.remote_ip, requests_count + 1, expires_in: 1.minute)
  end

  def requests_count
    Rails.cache.fetch(request.remote_ip) { 1 }
  end

  def requests_limit
    Rails.cache.fetch('max_requests_per_minute') { 200 }
  end

  def too_many_requests_error
    record_throttle unless ip_lock?
    set_ip_lock
    render json: { 'errors': { 'throttle': 'request limit reached' } }, status: :too_many_requests
  end

  def record_throttle
    Throttle.create(count: requests_count, remote_ip: request.remote_ip)
  end

  def set_ip_lock
    Rails.cache.write(ip_key, ip_key, expires_in: 1.minute)
  end

  def ip_lock?
    return false unless Rails.cache.fetch(ip_key)

    true
  end

  def ip_key
    "#{request.remote_ip}_lock"
  end
end
