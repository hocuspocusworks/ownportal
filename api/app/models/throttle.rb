# == Schema Information
#
# Table name: throttles
#
#  id         :bigint           not null, primary key
#  count      :integer
#  remote_ip  :string
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Throttle < ApplicationRecord
end
