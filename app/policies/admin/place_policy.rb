module Admin
  class PlacePolicy < BasePolicy
    class Scope < Scope
      def resolve
        scope
      end
    end

    def index?
      privileges.customer_service? || privileges.admin?
    end

    def new?
      privileges.admin?
    end

    def edit?
      privileges.admin?
    end

    def update?
      privileges.customer_service? || privileges.admin?
    end

    def create?
      privileges.admin?
    end

    def permitted_attributes
      allowed_attributes = [
        :price_per_km_cents,
        :factor_per_distance
      ]
      if privileges.admin?
        allowed_attributes += [
          :nombre,
          :country,
          :lat,
          :lon,
          :enabled
        ]
      end
      allowed_attributes
    end
  end
end
