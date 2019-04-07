class ShippingRequest < ActiveRecord::Base
  module GenerateService
    class GenericRequest
      protected

      def customer_address_attributes
        @resource
          .customer_address
          .attributes
          .slice(
            "lat",
            "lon",
            "ciudad",
            "barrio",
            "nombre",
            "parroquia",
            "referencia",
            "direccion_uno",
            "direccion_dos",
            "codigo_postal",
            "numero_convencional"
          )
      end
    end
  end
end
