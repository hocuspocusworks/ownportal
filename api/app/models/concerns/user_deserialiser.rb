class UserDeserialiser
  def self.deserialise(resource, params, _user)
    user = resource || User.new
    user.email = params[:email] || resource&.email
    user.password = params[:password] || resource&.password
    user
  end
end
