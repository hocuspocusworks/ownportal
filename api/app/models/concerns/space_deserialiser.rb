class SpaceDeserialiser
  def self.deserialise(resource, params, user)
    space = resource || Space.new
    space.name = params[:name] || resource&.name
    space.description = params[:description] || resource&.group
    space.path = space.name.parameterize
    space.user = user
    space
  end
end
