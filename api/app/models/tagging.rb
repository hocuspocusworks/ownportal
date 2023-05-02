# == Schema Information
#
# Table name: taggings
#
#  id           :integer          not null, primary key
#  tag_id       :bigint
#  favourite_id :bigint
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Tagging < ApplicationRecord
  belongs_to :favourite
  belongs_to :tag
end
