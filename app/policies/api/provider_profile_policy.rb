module Api
  class ProviderProfilePolicy < ::ApplicationPolicy
    class PublicScope < Scope
      def resolve
        place = user ? user.current_place : Place.default
        scope.with_status(:active).with_enabled_offices_in(place)
      end
    end

    def customer_show?
      user.current_place.present? if user else true
    end
  end
end
