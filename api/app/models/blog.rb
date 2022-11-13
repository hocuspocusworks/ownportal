# == Schema Information
#
# Table name: blogs
#
#  id             :bigint           not null, primary key
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
  after_commit :generate_blog, on: [:create, :update]
  after_commit :remove_blog, on: :destroy
  after_commit :generate_feed

  def generate_html_file_name
    self.html_file_name = heading.parameterize
  end

  def remove_blog
    RemoveBlog.perform_later(id, space.id)
  end

  def generate_blog
    GenerateBlog.perform_later(id, space.id)
  end

  def generate_feed
    GenerateFeed.perform_later(id, space.id)
  end
end
