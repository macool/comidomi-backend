module Admin
  class ProviderLunchPolicy < BasePolicy
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

    def edit?
      privileges.customer_service? || privileges.admin?
    end

    def new?
      privileges.customer_service? || privileges.admin?
    end

    def new_group?
      new?
    end

    def new_promo_item?
      new?
    end

    def create?
      new?
    end

    def update?
      edit?
    end

    def permitted_attributes
      [
        :provider_profile_id,
        :precio,
        lunch_items_attributes: [
          :id,
          :kind,
          :name,
          :_destroy
        ]
      ]
    end
  end
end
