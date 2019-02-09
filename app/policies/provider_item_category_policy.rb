class ProviderItemCategoryPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(
        provider_profile_id: [
          nil,
          user.provider_profile.id
        ]
      )
    end
  end

  def index?
    user.provider_profile.present?
  end
end
