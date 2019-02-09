module Admin
  class ProviderItemCategoryPolicy < BasePolicy
    class Scope < Scope
      def resolve
        scope
      end
    end

    def index?
      privileges.customer_service? || privileges.admin?
    end

    def new?
      index?
    end

    def edit?
      index?
    end

    def create?
      new?
    end

    def update?
      edit?
    end

    def permitted_attributes
      [:nombre]
    end
  end
end
