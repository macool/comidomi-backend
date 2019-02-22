module Admin
  class UserPolicy < BasePolicy
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
      privileges.admin?
    end

    def update?
      edit?
    end

    def new?
      edit?
    end

    def create?
      new?
    end

    def permitted_attributes
      [
        :name,
        :nickname,
        :email,
        :ciudad,
        :phone_number,
        :fecha_nacimiento,
        privileges: []
      ]
    end

    def permitted_attributes_with_password
      # programatically permit the following so
      # we don't mistakenly override
      permitted_attributes + [
        :password,
        :password_confirmation
      ]
    end
  end
end
