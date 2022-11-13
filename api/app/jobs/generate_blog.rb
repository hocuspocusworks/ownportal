class GenerateBlog < ApplicationJob
  include ActionView::Helpers

  def perform(blog_id, space_id)
    @blog = Blog.find(blog_id)
    @space = Space.find(space_id)

    call
  end

  def call
    template = File.read(blog_template)
    result = ERB.new(template).result(binding)
    save_to_file(result)
  end

  private

  def save_to_file(result)
    File.open(full_html_path, 'w+') do |file|
      file.write(result)
    end
  end

  def full_html_path
    "#{blog_path}/#{@blog.html_file_name}.html"
  end

  def blog_template
    "#{Rails.public_path}/blog.erb"
  end

  def blog_path
    Rails.configuration.space_path + @space.path
  end
end
