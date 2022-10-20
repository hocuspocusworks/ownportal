# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  email           :string           not null
#  password_digest :string
#  token           :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  sysadmin        :boolean
#  settings        :jsonb
#  deactivated_at  :datetime
#  last_logged_in  :datetime
#
class Session < ApplicationRecord
  self.table_name = 'users'
end
