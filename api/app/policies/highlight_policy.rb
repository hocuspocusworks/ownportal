class HighlightPolicy < ApplicationPolicy
  def index?
    true
  end

  def create?
    true
  end

  def update?
    current_user? || admin?
  end

  def destroy?
    current_user? || admin?
  end

  def permitted_attributes
    [:keyword, :colour, :user_id]
  end

  class Scope < ApplicationScope
    def resolve
      scope.where(user_id: user.id)
    end
  end
end
