# == Schema Information
#
# Table name: users
#
#  id                    :integer          not null, primary key
#  email                 :string           not null
#  password_digest       :string
#  token                 :string           not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  sysadmin              :boolean
#  settings              :text
#  deactivated_at        :datetime
#  last_logged_in        :datetime
#  subscription_date     :date
#  subscription_end_date :date
#
require "test_helper"

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
