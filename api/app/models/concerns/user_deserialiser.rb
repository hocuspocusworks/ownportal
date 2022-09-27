class UserDeserialiser
  def self.deserialise(resource, params, _user)
    user = resource || User.new
    user.email = params[:email] || resource&.email
    user.password = params[:password] unless params[:password].nil?
    user.settings = params[:settings] || resource&.settings
    user
  end
end
