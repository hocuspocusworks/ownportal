class NotificationPolicy < ApplicationPolicy
  def index?
    true
  end

  def count?
    true
  end

  def read?
    true
  end

  def show?
    true
  end

  def create?
    false
  end

  def update?
    false
  end

  def destroy?
    false
  end

  def permitted_attributes
    [read_ids: []]
  end

  class Scope < ApplicationScope
    def resolve
      scope.where(user_id: user.id)
    end
  end
end
