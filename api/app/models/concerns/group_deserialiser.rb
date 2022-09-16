class GroupDeserialiser
  def self.deserialise(params, user)
    group = Group.new
    group.name = params[:name]
    group.user = user
    group
  end
end
