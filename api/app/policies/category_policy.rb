class CategoryPolicy < ApplicationPolicy
  def index?
    true
  end

  def update?
    admin?
  end

  def destroy?
    admin?
  end

  class Scope < ApplicationScope
    def resolve
      scope.all
    end
  end
end
