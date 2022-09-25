class SessionDeserialiser
  def self.deserialise(resource, params, user)
    object = resource || Session.new
    object.email = params[:email] || resource&.email
    object.password_digest = params[:password] || resource&.password
    object
  end
end
