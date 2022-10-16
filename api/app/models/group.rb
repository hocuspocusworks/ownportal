# == Schema Information
#
# Table name: groups
#
#  id         :bigint           not null, primary key
#  name       :string
#  user_id    :bigint
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  tags       :jsonb
#
class Group < ApplicationRecord
  belongs_to :user

  has_many :streams, dependent: :destroy
  has_many :sources, through: :streams

  validates :name, presence: true

  scope :with_name, ->(name, user) { where('name = ? AND user_id = ?', name, user.id) }
end
