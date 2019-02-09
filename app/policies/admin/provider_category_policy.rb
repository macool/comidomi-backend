module Admin
  class ProviderCategoryPolicy < BasePolicy
    class Scope < Scope
      def resolve
        scope
      end
    end

    def index?
      privileges.customer_service? || privileges.admin?
    end

    def edit?
      privileges.admin?
    end

    def update?
      edit?
    end

    def permitted_attributes
      [
        :titulo,
        :descripcion,
        :imagen,
        :imagen_cache,
        :remove_imagen,
        :status
      ]
    end
  end
end
