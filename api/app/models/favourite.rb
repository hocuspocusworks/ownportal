# == Schema Information
#
# Table name: favourites
#
#  id             :bigint           not null, primary key
#  description    :string
#  link           :string
#  published_date :datetime
#  publisher      :string
#  title          :string
#  user_id        :bigint
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class Favourite < ApplicationRecord
  has_many :taggings
  has_many :tags, through: :taggings
  belongs_to :user
end
