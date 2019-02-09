class PlacePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.enabled
    end
  end

  def index?
    true
  end
end
