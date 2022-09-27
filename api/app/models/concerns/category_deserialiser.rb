class CategoryDeserialiser
  def self.deserialise(resource, params, user)
    category = resource || Category.new
    category.name = params[:name] || resource&.name
    category
  end
end
