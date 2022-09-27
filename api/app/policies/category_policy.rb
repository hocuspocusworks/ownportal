class CategoryPolicy < ApplicationPolicy
  def index?
    true
  end

  def create?
    admin?
  end

  def update?
    admin?
  end

  def destroy?
    admin?
  end

  def permitted_attributes
    [:name]
  end

  class Scope < ApplicationScope
    def resolve
      scope.all
    end
  end
end
