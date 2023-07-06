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
class User < ApplicationRecord
  has_secure_password
  has_secure_token

  has_many :blogs, dependent: :delete_all
  has_many :spaces, dependent: :destroy
  has_many :groups, dependent: :destroy
  has_many :streams, through: :groups, dependent: :destroy
  has_many :highlights, dependent: :destroy
  has_many :favourites, dependent: :destroy
  has_many :sources, foreign_key: 'creator_id', dependent: :nullify

  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    format: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/

  validates :password, length: { minimum: 6, allow_nil: true }

  after_create :default_group
  after_commit :send_registration_email

  scope :active, -> { where(deactivated_at: nil) }

  def safe_search?
    return true if settings&.include? 'safe'

    false
  end

  def history?
    return true if settings&.include? 'history'

    false
  end

  def default_group
    group = Group.create(name: 'Home', user: self)
    default_source(group)
  end

  def default_source(group)
    return unless source_exists?

    Stream.create(name: "Ownportal's blog", group_id: group.id, source_id: 259, user_id: id)
  end

  def source_exists?
    Source.exists?(259)
  end

  def send_registration_email
    Users::RegistrationEmail.new(self).send
  end
end
