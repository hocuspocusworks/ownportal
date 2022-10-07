# == Schema Information
#
# Table name: sources
#
#  id          :bigint           not null, primary key
#  description :string(512)
#  icon        :string
#  language    :string
#  name        :string           not null
#  timestamp   :datetime
#  url         :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  processed   :boolean          default(FALSE)
#  categories  :jsonb
#  published   :boolean
#  restricted  :boolean          default(TRUE), not null
#  creator_id  :bigint
#  counter     :integer
#  visibility  :integer          default(0)
#
class Explore < ApplicationRecord
  self.table_name = 'sources'
end
