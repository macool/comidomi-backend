module Admin
  class CustomerOrderDeliveryPolicy < BasePolicy
    class Scope < Scope
      def resolve
        scope
      end
    end

    def accept?
      privileges.customer_service? || privileges.admin?
    end

    def reject?
      privileges.customer_service? || privileges.admin?
    end
  end
end
