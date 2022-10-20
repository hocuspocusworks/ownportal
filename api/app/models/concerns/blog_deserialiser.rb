class BlogDeserialiser
  def self.deserialise(resource, params, user)
    blog = resource || Blog.new
    blog.title = params[:title] || resource&.title
    blog.heading = params[:heading] || resource&.heading
    blog.content = params[:content] || resource&.content
    blog.language = params[:language] || resource&.language
    blog.published_date = resource&.published_date || Time.now
    blog.active = params[:active] || resource&.active
    blog.space_id = params[:space_id] || resource&.space_id
    blog.user = user
    blog
  end
end
