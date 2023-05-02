# == Schema Information
#
# Table name: tags
#
#  id         :integer          not null, primary key
#  name       :string
#  colour     :string
#  user_id    :bigint
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Tag < ApplicationRecord
  belongs_to :user

  def self.find_or_create(tag_list, user)
    return [] if tag_list.nil?

    tags = Tag.where(name: tag_list)
    result_tags = []
    tag_list.each do |tag|
      result_tags.append(tags.find_by(name: tag) || Tag.create(name: tag, user: user))
    end
    result_tags
  end
end
