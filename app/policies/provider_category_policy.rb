class ProviderCategoryPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.with_status(:enabled)
    end
  end

  def index?
    true
  end

  def show?
    true
  end
end
