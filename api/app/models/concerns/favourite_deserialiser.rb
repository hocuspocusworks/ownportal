class FavouriteDeserialiser
  def self.deserialise(resource, params, user)
    favourite = resource || Favourite.new
    favourite.description = params[:description] || resource&.description
    favourite.link = params[:link] || resource&.link
    favourite.publisher = params[:publisher] || resource&.publisher
    favourite.title = params[:title] || resource&.title
    favourite.user = user
    favourite.tags = Tag.find_or_create(params[:tag_list], user)
    favourite
  end
end
