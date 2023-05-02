# == Schema Information
#
# Table name: favourites
#
#  id             :integer          not null, primary key
#  description    :string
#  link           :string
#  published_date :datetime
#  publisher      :string
#  title          :string
#  user_id        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  tags_json      :text
#
class Favourite < ApplicationRecord
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings
  belongs_to :user
end
