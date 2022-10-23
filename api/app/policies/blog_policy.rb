class BlogPolicy < ApplicationPolicy
  def index?
    true
  end

  def create?
    Space.find(record.space_id).user_id == user.id
  end

  def update?
    admin? || current_user?
  end

  def destroy?
    admin? || current_user?
  end

  def permitted_attributes
    [:language, :published_date, :heading, :content, :active, :space_id]
  end

  class Scope < ApplicationScope
    def resolve
      scope.where(user_id: user.id)
    end
  end
end
