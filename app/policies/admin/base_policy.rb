module Admin
  class BasePolicy < ::ApplicationPolicy
    protected

    def privileges
      user.privileges
    end
  end
end
