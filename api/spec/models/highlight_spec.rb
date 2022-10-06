# == Schema Information
#
# Table name: highlights
#
#  id         :bigint           not null, primary key
#  keyword    :string
#  colour     :string
#  user_id    :bigint
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Highlight, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
