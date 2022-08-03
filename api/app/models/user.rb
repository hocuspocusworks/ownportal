class User < ApplicationRecord
  has_secure_password
  has_secure_token

  has_many :streams, through: :groups

  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    format: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/

  validates :password, presence: true, length: { minimum: 6, maximum: 256 }

  def admin?
    role == 'admin'
  end
end
