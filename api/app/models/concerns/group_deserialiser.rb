class GroupDeserialiser
  def self.deserialise(resource, params, user)
    group = resource || Group.new
    group.name = params[:name] || resource&.name
    group.user = user
    group
  end
end
