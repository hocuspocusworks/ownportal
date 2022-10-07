class SourceDeserialiser
  def self.deserialise(resource, params, user)
    source = resource || Source.new
    source.description = params[:description] || resource&.description
    source.icon = params[:icon] || resource&.icon
    source.language = params[:language] || resource&.language
    source.name = params[:name] || resource&.name
    source.timestamp = params[:timestamp] || resource&.timestamp
    source.url = params[:url] || resource&.url
    source.processed = params[:processed] || resource&.processed
    source.published = params[:published] || resource&.published || true
    source.restricted = params[:restricted] || resource&.restricted || true
    source.visibility = params[:visibility] || resource&.visibility || 0
    source.categories = params[:categories] || resource&.categories
    source.creator = resource&.creator || user
    source
  end
end
