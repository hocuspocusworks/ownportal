class FavouriteDeserialiser
  def self.deserialise(resource, params, user)
    favourite = resource || Favourite.new
    favourite.description = params[:description] || resource&.description
    favourite.link = params[:link] || resource&.link
    favourite.publisher = params[:publisher] || resource&.publisher
    favourite.title = params[:title] || resource&.title
    favourite.published_date = params[:published_date] || resource&.published_date
    favourite.user = user
    favourite.tags = Tag.find_or_create(params[:tag_list], user)
    favourite.tags_json = params[:tag_list] || resource&.tags_json
    favourite
  end
end
