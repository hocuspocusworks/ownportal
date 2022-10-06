# == Schema Information
#
# Table name: highlights
#
#  id         :bigint           not null, primary key
#  keyword    :string
#  colour     :string
#  user_id    :bigint
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Highlight < ApplicationRecord
  belongs_to :user

  scope :with_id, ->(id) { Highlight.where(user_id: user.id).find_by(id) }
  scope :with_user, ->(user) { Highlight.find_by(user) }
end
