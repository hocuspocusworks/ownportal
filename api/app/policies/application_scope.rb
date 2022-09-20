class ApplicationScope
  attr_reader :user, :scope

  def initialize(user, scope)
    @user  = user
    @scope = scope
  end

  def resolve
    false
  end

  private

  def admin?
    @user.sysadmin?
  end
end
