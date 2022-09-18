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
  after_save :save_tags

  has_many :taggings
  belongs_to :user

  private

  def save_tags
    # noop
  end
end
