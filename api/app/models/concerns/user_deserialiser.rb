class UserDeserialiser
  def self.deserialise(resource, params, _user)
    user = resource || User.new
    user.email = params[:email] || resource&.email
    user.password = params[:password] unless params[:password].nil?
    user.settings = params[:settings] || resource&.settings
    user.sysadmin = params[:sysadmin] || resource&.sysadmin
    user.deactivated_at = params[:deactivated] == 'true' ? Time.now : nil
    user
  end
end
