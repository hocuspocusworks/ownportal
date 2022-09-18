class StreamDeserialiser
  def self.deserialise(resource, params, user)
    stream = resource || Stream.new
    stream.name = params[:name] || resource&.name
    stream.group = Group.with_name(params[:group], user)&.first || resource&.group
    stream.source = Source.with_url(params[:url])&.first || resource&.source
    stream
  end
end
