class ExplorePolicy < ApplicationPolicy
  def search?
    true
  end

  def rss?
    true
  end

  def top?
    true
  end

  def permitted_attributes
    [:categories, :keyword, :safe, :url]
  end
end
