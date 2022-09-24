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
    true
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
    [:name, tags: []]
  end

  private

  def admin_and_user_permissions
    admin? || current_user?
  end
end
