module Admin
  class ProviderOfficePolicy < BasePolicy
    def permitted_attributes
      [
        :id,
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
          :hora_de_apertura
        ]
      ]
    end
  end
end
