# == Schema Information
#
# Table name: sources
#
#  id          :bigint           not null, primary key
#  description :string
#  icon        :string
#  language    :string
#  name        :string           not null
#  timestamp   :datetime
#  url         :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  processed   :boolean
#
class Explore < ApplicationRecord
  self.table_name = 'sources'
end
