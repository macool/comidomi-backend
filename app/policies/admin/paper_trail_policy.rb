module Admin
  class PaperTrailPolicy < BasePolicy
    class Scope < Scope
      def resolve
        scope
      end
    end

    def show?
      privileges.customer_service? || privileges.admin?
    end
  end
end
