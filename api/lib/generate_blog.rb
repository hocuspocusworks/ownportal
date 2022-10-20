class GenerateBlog
  include ActionView::Helpers

  def initialize(blog)
    @blog = blog
  end

  def call
    template = File.read(blog_template)
    ERB.new(template).result(binding)
  end

  private

  def blog_template
    "#{Rails.public_path}/blog.erb"
  end
end
