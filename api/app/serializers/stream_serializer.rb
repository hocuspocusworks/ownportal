class StreamSerializer < Blueprinter::Base
  identifier :id

  fields :name, :group_id

  association :source, blueprint: SourceSerializer
end
