class ProviderDispatcherPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(
        provider_office_id: user.provider_profile.offices.pluck(:id)
      )
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

  def permitted_attributes
    [
      :email,
      :provider_office_id
    ]
  end

  private

  def is_provider?
    user.provider_profile.present?
  end
end
