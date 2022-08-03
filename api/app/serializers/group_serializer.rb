class GroupSerializer < Blueprinter::Base
  identifier :id

  fields :name, :user_id

  association :streams, blueprint: StreamSerializer
end
