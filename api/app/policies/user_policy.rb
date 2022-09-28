# Pundit is resource-based, not controller-based. When you call authorize and pass it a resource, Pundit cares about the action name and the resource type, but it does not care about the controller name.
class UserPolicy < ApplicationPolicy
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

  def delete?
    admin_and_user_permissions
  end

  def permitted_attributes
    basic = [:email, :password, :password_confirmation, settings: []]

    return basic if user.nil?

    basic += [:role] if admin?
    basic - [:email] unless user.nil?
  end

  private

  def admin_and_user_permissions
    admin? || record.id == user.id
  end
end
