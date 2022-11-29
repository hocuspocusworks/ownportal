# == Schema Information
#
# Table name: notifications
#
#  id           :bigint           not null, primary key
#  article_id   :bigint
#  highlight_id :bigint
#  user_id      :bigint
#  stale        :boolean
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Notification < ApplicationRecord
  belongs_to :article
  belongs_to :highlight
  belongs_to :user
end
