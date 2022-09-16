class StreamPolicy < ApplicationPolicy
  class Scope < ApplicationScope
    def resolve
      if user.admin?
        scope.all
      else
        scope.where(id: user.id)
      end
    end
  end

  def index?
    user.admin?
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
    user.admin? || record.pluck(:user_id)[0] == user.id
  end
end
