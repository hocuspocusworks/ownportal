class StreamDeserialiser
  def self.deserialise(resource, params, user)
    stream = resource || Stream.new
    stream.name = params[:name]
    stream.group = Group.with_name(params[:group], user)&.first
    stream.source = Source.with_url(params[:url])&.first
    stream
  end
end
