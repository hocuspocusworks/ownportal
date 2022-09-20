module Admin
  class SourcePolicy < ApplicationPolicy
    def index?
      admin?
    end

    def update?
      admin?
    end

    class Scope < ApplicationScope
      def resolve
        admin? ? scope.all : scope.none
      end
    end
  end
end
