class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    false
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
    []
  end

  private

  def admin?
    user.sysadmin?
  end

  def current_user?
    return record.id == user.id if record.is_a? User

    record.user_id == user.id
  end
end
