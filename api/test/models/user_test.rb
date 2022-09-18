# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  email           :string           not null
#  password_digest :string
#  token           :string
#  role            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  sysadmin        :boolean
#
require "test_helper"

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
