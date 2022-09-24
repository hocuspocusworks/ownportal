class StreamPolicy < ApplicationPolicy
  class Scope < ApplicationScope
    def resolve
      if admin?
        scope.all
      else
        scope.where(id: user.id)
      end
    end
  end

  def index?
    admin?
  end

  def create?
    admin_and_user_permissions
  end

  def show?
    admin_and_user_permissions
  end

  def update?
    admin_and_user_permissions
  end

  def destroy?
    admin_and_user_permissions
  end

  def permitted_attributes
    %i[name group url]
  end

  private

  def admin_and_user_permissions
    admin? || current_user?
  end
end
