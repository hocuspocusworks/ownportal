# == Schema Information
#
# Table name: streams
#
#  id         :bigint           not null, primary key
#  name       :string
#  group_id   :bigint
#  source_id  :bigint
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
class Stream < ApplicationRecord
  belongs_to :group
  belongs_to :source
  belongs_to :user

  scope :with_streams, (lambda do |id, user|
    where(user_id: user.id).where(group_id: id).where(sources: { visibility: visibility(user) }).joins(:user).joins(:source)
  end)

  class << self
    def visibility(user)
      return [2] if user.safe_search?

      [1, 2]
    end
  end
end
