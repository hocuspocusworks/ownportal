# == Schema Information
#
# Table name: spaces
#
#  id          :bigint           not null, primary key
#  name        :string           not null
#  description :string
#  path        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint           not null
#
class Space < ApplicationRecord
  belongs_to :user

  validates_uniqueness_of :name
  validates_uniqueness_of :path

  before_save :create_space

  def create_space
    Dir.mkdir(full_path) unless File.exist?(full_path)
  end

  def full_path
    Rails.configuration.space_path + path
  end
end
