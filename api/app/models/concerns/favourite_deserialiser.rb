class FavouriteDeserialiser
  def self.deserialise(resource, params, user)
    favourite = resource || Favourite.new
    favourite.description = params[:description]
    favourite.link = params[:link]
    favourite.publisher = params[:publisher]
    favourite.title = params[:title]
    favourite.user = user
    favourite.tags = Tag.find_or_create(params[:tag_list], user)
    favourite
  end
end
