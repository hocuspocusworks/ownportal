# == Schema Information
#
# Table name: histories
#
#  id         :bigint           not null, primary key
#  article_id :bigint
#  user_id    :bigint
#  stale      :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class History < ApplicationRecord
  belongs_to :article
  belongs_to :user
end
