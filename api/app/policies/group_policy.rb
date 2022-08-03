class GroupPolicy < ApplicationPolicy
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
    %i[name]
  end

  private

  def admin_and_user_permissions
    user.admin? || record.user_id == user.id
  end
end
