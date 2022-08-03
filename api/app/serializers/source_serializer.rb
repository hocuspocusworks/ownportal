class SourceSerializer < Blueprinter::Base
  identifier :id

  fields :name, :description, :icon, :language, :url
end
