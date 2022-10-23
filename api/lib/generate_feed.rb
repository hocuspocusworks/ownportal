require 'builder'

class GenerateFeed
  include ActionView::Helpers

  def initialize(blog, space)
    @blog = blog
    @space = space
  end

  def call
    xml = Builder::XmlMarkup.new

    xml.instruct!
    xml.channel do
      xml.title(@space.name)
      xml.link(space_url)
      xml.description(@space.description)
      items.each do |item|
        xml.item do
          xml.title(item.heading)
          xml.link(blog_url(item))
          xml.description(item.content)
        end
      end
    end

    File.open(full_feed_path, 'w+') do |file|
      file.write(xml)
    end
  end

  private

  def items
    Blog.limit(10).order(published_date: :desc).where(user_id: @space.user_id)
  end

  def blog_url(item)
    "#{space_url}/#{item.html_file_name}.html"
  end

  def space_url
    "#{ownportal_space_url}#{@space.path}"
  end

  def ownportal_space_url
    'https://space.ownportal.net/'
  end

  def full_feed_path
    "#{blog_path}/feed.xml"
  end

  def blog_path
    Rails.configuration.space_path + @space.path
  end
end
