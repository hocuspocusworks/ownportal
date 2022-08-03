class Group < ApplicationRecord
  belongs_to :user

  has_many :streams
  has_many :sources, through: :streams

  validates :name, presence: true

  # scope :for_user, ->(user) { where('user_id = ?', user.id) }
  scope :with_name, ->(name, user) { where('name = ? AND user_id = ?', name, user.id) }
end
