# == Schema Information
#
# Table name: streams
#
#  id         :integer          not null, primary key
#  name       :string
#  group_id   :integer
#  source_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#
class Stream < ApplicationRecord
  belongs_to :group
  belongs_to :source
  belongs_to :user
end
