class HistoryDeserialiser
  def self.deserialise(resource, params, user)
    history = resource || History.new
    history.article_id = params[:article_id] || resource&.article_id
    history.stale = params[:stale] || resource&.stale
    history.user = user
    history
  end
end
