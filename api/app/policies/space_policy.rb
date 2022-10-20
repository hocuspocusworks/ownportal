class SpacePolicy < ApplicationPolicy
  def index?
    true
  end

  def create?
    true
  end

  def update?
    admin? || current_user?
  end

  def destroy?
    admin? || current_user?
  end

  def permitted_attributes
    [:name, :description]
  end

  class Scope < ApplicationScope
    def resolve
      scope.where(user_id: user.id)
    end
  end
end
