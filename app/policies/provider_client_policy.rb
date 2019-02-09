class ProviderClientPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(
        provider_profile_id: user.provider_profile.id
      )
    end
  end

  def index?
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

  def permitted_attributes
    [
      :notas,
      :ruc,
      :nombres,
      :direccion,
      :telefono,
      :email
    ]
  end

  private

  def is_provider?
    user.provider_profile.present?
  end
end
