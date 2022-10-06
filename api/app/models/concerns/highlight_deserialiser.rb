class HighlightDeserialiser
  def self.deserialise(resource, params, user)
    highlight = resource || Highlight.new
    highlight.keyword = params[:keyword] || resource&.keyword
    highlight.colour = params[:colour] || resource&.colour
    highlight.user = user
    highlight
  end
end
