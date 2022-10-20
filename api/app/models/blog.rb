# == Schema Information
#
# Table name: blogs
#
#  id             :bigint           not null, primary key
#  title          :string
#  language       :string
#  published_date :datetime
#  heading        :string
#  content        :text
#  active         :boolean
#  user_id        :bigint
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  space_id       :bigint           not null
#  html_file_name :string
#
class Blog < ApplicationRecord
  belongs_to :space
  belongs_to :user

  before_save :generate_html_file_name
  after_commit :generate_blog

  def generate_html_file_name
    self.html_file_name = title.parameterize
  end

  def generate_blog
    result = GenerateBlog.new(self).call
    File.open(full_path, 'w+') do |file|
      file.write(result)
    end
  end

  def full_path
    "#{blog_path}/#{html_file_name}.html"
  end

  def blog_path
    Rails.configuration.space_path + space.path
  end
end
