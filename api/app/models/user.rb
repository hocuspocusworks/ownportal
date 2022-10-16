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
#
class User < ApplicationRecord
  has_secure_password
  has_secure_token

  has_many :streams, through: :groups
  has_many :highlights

  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    format: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/

  validates :password, length: { minimum: 6, allow_nil: true }

  after_create :default_group

  def safe_search?
    return true if settings.include? 'safe'

    false
  end

  def default_group
    Group.create(name: 'Home', user: self)
  end
end
