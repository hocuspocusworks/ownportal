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
class User < ApplicationRecord
  has_secure_password
  has_secure_token

  has_many :streams, through: :groups

  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    format: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/

  validates :password, length: { minimum: 6, allow_nil: true }

  def admin?
    role == 'admin'
  end

  def sysadmin?
    sysadmin
  end
end
