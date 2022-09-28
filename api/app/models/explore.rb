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
#  categories  :jsonb
#  published   :boolean
#  restricted  :boolean          default(TRUE), not null
#  creator_id  :bigint
#  counter     :integer
#
class Explore < ApplicationRecord
  self.table_name = 'sources'
end
