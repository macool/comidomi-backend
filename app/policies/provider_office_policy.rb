class ProviderOfficePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(
        provider_profile_id: user.provider_profile.id
      )
    end
  end

  def show?
    is_provider?
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

  def permitted_attributes
    [
      :place_id,
      :telefono,
      :direccion,
      :enabled,
      :lat,
      :lon,
      weekdays_attributes: [
        :id,
        :day,
        :abierto,
        :hora_de_cierre,
        :hora_de_apertura,
      ]
    ]
  end

  private

  def is_provider?
    user.provider_profile.present?
  end
end
