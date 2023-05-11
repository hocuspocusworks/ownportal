RailsPerformance.setup do |config|
  config.redis    = Redis::Namespace.new("#{Rails.env}-rails-performance", redis: Redis.new)
  config.duration = 24.hours

  config.debug    = false # currently not used>
  config.enabled  = false

  # default path where to mount gem,
  # alternatively you can mount the RailsPerformance::Engine in your routes.rb
  config.mount_at = '/rails/performance'

  # protect your Performance Dashboard with HTTP BASIC password
  config.http_basic_authentication_enabled   = true
  config.http_basic_authentication_user_name = 'ownportal'
  config.http_basic_authentication_password  = 'ownportal_performance'

  # if you need an additional rules to check user permissions
  config.verify_access_proc = proc { |controller| true }
  # for example when you have `current_user`
  # config.verify_access_proc = proc { |controller| controller.current_user && controller.current_user.admin? }

  # store custom data for the request
  # config.custom_data_proc = proc do |env|
  #   request = Rack::Request.new(env)
  #   {
  #     email: request.env['warden'].user&.email, # if you are using Devise for example
  #     user_agent: request.env['HTTP_USER_AGENT']
  #   }
  # end

  # config home button link
  config.home_link = '/'

  config.skipable_rake_tasks = ['webpacker:compile']
end if defined?(RailsPerformance)
