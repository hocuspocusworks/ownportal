# == Schema Information
#
# Table name: sources
#
#  id          :bigint           not null, primary key
#  description :string
#  icon        :string
#  language    :string
#  name        :string           not null
#  timestamp   :datetime
#  url         :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Source < ApplicationRecord
  has_many :streams

  validates :name, presence: true, length: { minimum: 3, maximum: 64 }

  validates :description, length: { maximum: 256 }

  scope :with_url, ->(url) { where(url: url) }
  scope :with_keyword, ->(keyword) { where('name like ?', "%#{keyword}%") }
end
