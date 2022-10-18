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
end
