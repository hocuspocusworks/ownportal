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
#
class Stream < ApplicationRecord
  belongs_to :group
  belongs_to :source
end
