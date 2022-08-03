class Source < ApplicationRecord
  has_many :streams

  validates :name, presence: true, length: { minimum: 3, maximum: 64 }

  validates :description, length: { maximum: 256 }

  scope :with_url, ->(url) { where('url = ?', url) }
end
