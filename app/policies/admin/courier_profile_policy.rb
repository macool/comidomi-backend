module Admin
  class CourierProfilePolicy < BasePolicy
    def index?
      privileges.customer_service? || privileges.admin?
    end

    def new?
      index?
    end
  end
end
