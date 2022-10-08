# == Schema Information
#
# Table name: sources
#
#  id          :bigint           not null, primary key
#  description :string(512)
#  icon        :string
#  language    :string
#  name        :string           not null
#  timestamp   :datetime
#  url         :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  processed   :boolean          default(FALSE)
#  categories  :jsonb
#  published   :boolean
#  restricted  :boolean          default(TRUE), not null
#  creator_id  :bigint
#  counter     :integer
#  visibility  :integer          default("nobody")
#
class Source < ApplicationRecord
  enum :visibility, { nobody: 0, restricted: 1, safe: 2 }

  has_many :streams

  belongs_to :creator, class_name: 'User'

  validates :name, presence: true, length: { minimum: 3, maximum: 64 }
  validates :description, length: { maximum: 512 }

  scope :with_processed, -> { where(processed: true) }
  scope :with_non_processed, -> { where(processed: false) }
  scope :with_admin, (lambda do
    select('sources.*,users.sysadmin').joins(:creator).where(users: { sysadmin: true }).order(updated_at: :desc)
  end)
  scope :with_non_admin, (lambda do
    select('sources.*,users.sysadmin').joins(:creator).where(users: { sysadmin: false }).order(updated_at: :desc)
  end)
  scope :with_safe, -> { where(visibility: Source.visibilities[:safe]) }
  scope :with_allowed, (lambda do
    where('visibility=? OR visibility=?', Source.visibilities[:restricted], Source.visibilities[:safe])
  end)
  scope :with_url, ->(url) { where(url: url) }
  scope :with_keyword, ->(keyword) { where('LOWER(name) like ?', "%#{keyword.downcase}%") }
end
