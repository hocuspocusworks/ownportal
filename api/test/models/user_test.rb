# == Schema Information
#
# Table name: users
#
#  id                            :bigint           not null, primary key
#  email                         :string           not null
#  password_digest               :string
#  token                         :string           not null
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  sysadmin                      :boolean
#  settings                      :jsonb
#  deactivated_at                :datetime
#  last_logged_in                :datetime
#  subscription_date             :date
#  subscription_end_date         :date
#  registration_key              :string
#  registration_key_activated_on :date
#
require "test_helper"

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
