# == Schema Information
#
# Table name: articles
#
#  id             :bigint           not null, primary key
#  description    :string
#  link           :string
#  published_date :datetime
#  publisher      :string
#  title          :string
#  stale          :boolean
#  source_id      :bigint
#  user_id        :bigint
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class Article < ApplicationRecord
  belongs_to :source
end
