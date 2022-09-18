module Admin
  class SourcePolicy < ApplicationPolicy
    def index?
      user.sysadmin?
    end

    def update?
      user.sysadmin?
    end

    class Scope < ApplicationScope
      def resolve
        user.sysadmin? ? scope.all : scope.none
      end
    end
  end
end
