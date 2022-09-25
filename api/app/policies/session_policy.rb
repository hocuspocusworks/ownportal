class SessionPolicy < ApplicationPolicy
  class Scope < ApplicationScope
    def resolve
      if admin?
        scope.all
      else
        scope.where(id: user.id)
      end
    end
  end

  def create?
    true
  end

  def destroy?
    true
  end

  def permitted_attributes
    [:email, :password]
  end
end
