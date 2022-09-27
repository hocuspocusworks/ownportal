# Pundit is resource-based, not controller-based. When you call authorize and pass it a resource, Pundit cares about the action name and the resource type, but it does not care about the controller name.
class SourcePolicy < ApplicationPolicy
  def index?
    true
  end

  def create?
    true
  end

  def update?
    admin?
  end

  def delete?
    admin?
  end

  def permitted_attributes
    [:name, :description, :url, :icon, :language, :published, categories: []]
  end

  class Scope < ApplicationScope
    def resolve
      scope.where(published: true)
    end
  end
end
