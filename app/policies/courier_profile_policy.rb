class CourierProfilePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(
        user_id: user.id
      )
    end
  end

  def create?
    # if the user doesn't have a courier profile already
    user.courier_profile.nil?
  end

  def permitted_attributes
    [
      :ruc,
      :email,
      :nombres,
      :telefono,
      :place_id,
      :tipo_licencia,
      :fecha_nacimiento,
      # :tipo_medio_movilizacion
    ]
  end
end
