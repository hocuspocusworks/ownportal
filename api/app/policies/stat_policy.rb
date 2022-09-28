class StatPolicy < ApplicationPolicy
  def index?
    admin?
  end

  class Scope < ApplicationScope
    def resolve
      scope.all
    end
  end
end
