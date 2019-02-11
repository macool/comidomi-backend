module Admin
  class ShippingRequestPolicy < BasePolicy
    class Scope < Scope
      def resolve
        scope
      end
    end

    def index?
      privileges.customer_service? || privileges.admin?
    end

    def show?
      index?
    end

    def assign?
      index?
    end

    def cancel?
      index?
    end
  end
end
