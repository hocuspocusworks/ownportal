class GroupsQueries
  attr_reader :relation

  def initialize(relation: Group.all)
    @relation = relation
  end

  def with_streams(user_id)
    Group.left_outer_joins(:streams)
         .left_outer_joins(:sources)
         .where('groups.user_id = ?', user_id)
         .distinct
  end
end
