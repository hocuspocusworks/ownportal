class FavouritePolicy < ApplicationPolicy
  def index?
    true
  end

  def create?
    true
  end

  def update?
    true
  end

  def destroy?
    admin? || current_user?
  end

  def permitted_attributes
    [:description, :link, :publisher, :title, :published_date, tag_list: []]
  end

  class Scope < ApplicationScope
    def resolve
      scope.where(user: user)
    end
  end
end
