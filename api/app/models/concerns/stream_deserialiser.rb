class StreamDeserialiser
  def self.deserialise(params, user)
    stream = Stream.new
    stream.name = params[:name]
    stream.group = Group.with_name(params[:group], user)&.first
    stream.source = Source.with_url(params[:url])&.first
    stream
  end
end
