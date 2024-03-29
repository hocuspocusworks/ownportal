require 'builder'

class GenerateFeed < ApplicationJob
  include ActionView::Helpers

  def perform(blog_id, space_id)
    @blog = Blog.find(blog_id)
    @space = Space.find(space_id)

    call
  end

  def call
    xml = Builder::XmlMarkup.new

    xml.instruct!
    xml.rss(version: '2.0') do
      xml.channel do
        xml.title(@space.name)
        xml.link(space_url)
        xml.description(@space.description)
        items.each do |item|
          xml.item do
            xml.title(item.heading)
            xml.link(blog_url(item))
            xml.description(item.content)
            xml.pubDate(item.published_date)
          end
        end
      end
    end

    File.open(full_feed_path, 'w+') do |file|
      file.write(xml.target!)
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
