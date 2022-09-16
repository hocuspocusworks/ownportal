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
#
class SourceSerializer < Blueprinter::Base
  identifier :id

  fields :name, :description, :icon, :language, :url
end
