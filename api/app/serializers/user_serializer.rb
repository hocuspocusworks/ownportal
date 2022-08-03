class UserSerializer < Blueprinter::Base
  identifier :id

  field :role, default: 'user'

  fields :email, :token
end
