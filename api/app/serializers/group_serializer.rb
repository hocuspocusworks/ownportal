# == Schema Information
#
# Table name: groups
#
#  id         :bigint           not null, primary key
#  name       :string
#  user_id    :bigint
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class GroupSerializer < Blueprinter::Base
  identifier :id

  fields :name, :user_id

  association :streams, blueprint: StreamSerializer
end
