module Admin
  class ProviderItemPolicy < BasePolicy
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

    def create?
      new?
    end

    def update?
      edit?
    end

    def permitted_attributes
      [
        :titulo,
        :descripcion,
        :observaciones,
        :unidad_medida,
        :precio,
        :cantidad,
        :volumen,
        :peso,
        :en_stock,
        :provider_item_category_id,
        :provider_profile_id,
        :is_group,
        :parent_provider_item_id,
        imagenes_attributes: [
          :id,
          :imagen,
          :imagen_cache,
          :remove_imagen,
          :_destroy
        ]
      ]
    end
  end
end
