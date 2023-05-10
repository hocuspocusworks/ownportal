class ArticlePolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    false
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
    [:sort, :source, :group]
  end

  class Scope < ApplicationScope
    def resolve
      scope.where(user_id: user.id)
    end
  end
end
