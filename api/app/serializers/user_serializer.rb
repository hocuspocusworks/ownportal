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
#
class UserSerializer < Blueprinter::Base
  identifier :id

  field :role, default: 'user'

  fields :email, :token
end
