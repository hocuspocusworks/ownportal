# == Schema Information
#
# Table name: users
#
#  id                           :integer          not null, primary key
#  email                        :string           not null
#  password_digest              :string
#  token                        :string           not null
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  sysadmin                     :boolean
#  settings                     :text
#  deactivated_at               :datetime
#  last_logged_in               :datetime
#  subscription_date            :date
#  subscription_end_date        :date
#  registration_token           :string
#  registration_email_last_sent :datetime
#  registration_confirmed       :datetime         default(NULL)
#  registration_retries         :integer          default(0), not null
#  registration_date            :datetime
#
class Session < ApplicationRecord
  self.table_name = 'users'
end
