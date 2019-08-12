class ProviderItemPolicy < ApplicationPolicy
  class ProviderScope < Scope
    def resolve
      scope.where(
        provider_profile_id: user.provider_profile.id
      )
    end
  end

  class PublicScope < Scope
    def resolve
      scope.in_stock_and_available_or_publicly_available
    end
  end

  def index?
    is_provider?
  end

  def show?
    is_provider?
  end

  def create?
    is_provider?
  end

  def update?
    is_provider?
  end

  def destroy?
    is_provider?
  end

  def read?
    true
  end

  def permitted_attributes
    [
      :titulo,
      :descripcion,
      :unidad_medida,
      :precio,
      :precio_currency,
      :volumen,
      :peso,
      :observaciones,
      :cantidad,
      :en_stock,
      :provider_item_category_id,
      imagenes_attributes: [
        :id,
        :imagen,
        :_destroy
      ],
      provider_item_category_attributes: [
        :nombre
      ]
    ]
  end

  private

  def is_provider?
    user.provider_profile.present?
  end
end
