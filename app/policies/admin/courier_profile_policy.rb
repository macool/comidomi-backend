module Admin
  class CourierProfilePolicy < BasePolicy
    def index?
      privileges.customer_service? || privileges.admin?
    end

    def new?
      index?
    end

    def create?
      index?
    end

    def show?
      index?
    end

    def edit?
      index?
    end

    def update?
      index?
    end

    def priorities?
      index?
    end

    def permitted_attributes
      [
        :ruc,
        :email,
        :user_id,
        :nombres,
        :telefono,
        :place_id,
        :receive_calls,
        :call_priority,
        :tipo_licencia,
        :fecha_nacimiento,
        :tipo_medio_movilizacion
      ]
    end
  end
end
