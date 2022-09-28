# == Schema Information
#
# Table name: sources
#
#  id          :bigint           not null, primary key
#  description :string
#  icon        :string
#  language    :string
#  name        :string           not null
#  timestamp   :datetime
#  url         :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  processed   :boolean
#  categories  :jsonb
#  published   :boolean
#  restricted  :boolean          default(TRUE), not null
#  creator_id  :bigint
#  counter     :integer
#
class Source < ApplicationRecord
  has_many :streams

  belongs_to :creator, class_name: 'User'

  validates :name, presence: true, length: { minimum: 3, maximum: 64 }
  validates :description, length: { maximum: 256 }

  scope :with_processed, -> { where(processed: true) }
  scope :with_admin, (lambda do
    select('sources.*,users.sysadmin').joins(:creator).where(users: { sysadmin: true }).order(counter: :desc)
  end)
  scope :with_non_admin, (lambda do
    select('sources.*,users.sysadmin').joins(:creator).where(users: { sysadmin: false }).order(counter: :desc)
  end)
  scope :with_safe, -> { where(published: true).where(restricted: false) }
  scope :with_published, -> { where(published: true) }
  scope :with_url, ->(url) { where(url: url) }
  scope :with_keyword, ->(keyword) { where('LOWER(name) like ?', "%#{keyword.downcase}%") }
end
