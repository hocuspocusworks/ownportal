# == Schema Information
#
# Table name: blogs
#
#  id             :bigint           not null, primary key
#  title          :string
#  language       :string
#  published_date :datetime
#  heading        :string
#  content        :text
#  active         :boolean
#  user_id        :bigint
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  space_id       :bigint           not null
#
class Blog < ApplicationRecord
  belongs_to :space
  belongs_to :user
end
