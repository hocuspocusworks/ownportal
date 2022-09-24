class GroupPolicy < ApplicationPolicy
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
    true
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
    %i[name tags]
  end

  private

  def admin_and_user_permissions
    admin? || record.user_id == user.id
  end
end
