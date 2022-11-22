# == Schema Information
#
# Table name: users
#
#  id                    :bigint           not null, primary key
#  email                 :string           not null
#  password_digest       :string
#  token                 :string           not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  sysadmin              :boolean
#  settings              :jsonb
#  deactivated_at        :datetime
#  last_logged_in        :datetime
#  subscription_date     :date
#  subscription_end_date :date
#

require 'rails_helper'

describe User do
  context 'user' do
    it 'saving user' do
      expect do
        User.create(email: 'test@gmail.com', password: 'blabla')
      end.to change(User, :count).from(0).to(1)
    end
  end
end
