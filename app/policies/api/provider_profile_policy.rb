module Api
  class ProviderProfilePolicy < ::ApplicationPolicy
    class PublicScope < Scope
      def resolve
        place = user ? user.current_place : Place.default
        provider_statuses = [:active]
        if user.privileges.tester?
          provider_statuses << :for_testing
        end
        scope.with_status(*provider_statuses).with_enabled_offices_in(place)
      end
    end

    def customer_show?
      # user.current_place.present? if user else true
      true
    end
  end
end
