class ProviderLunchPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(
        provider_profile_id: user.provider_profile.id
      )
    end
  end

  def create?
    is_provider?
  end

  def permitted_attributes
    [
      :precio,
      lunch_items_attributes: [
        :kind,
        :name
      ]
    ]
  end

  private

  def is_provider?
    user.provider_profile.present?
  end
end
