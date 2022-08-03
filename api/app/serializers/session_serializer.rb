class SessionSerializer < Blueprinter::Base
  identifier :id

  fields :token, :email, :created_at, :updated_at
end
