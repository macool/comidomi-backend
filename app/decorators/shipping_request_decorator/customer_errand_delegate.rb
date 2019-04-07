class ShippingRequestDecorator < GenericResourceDecorator
  class CustomerErrandDelegate < ::Draper::Decorator
    delegate_all

    def address
      address_attributes["direccion_uno"] if address_attributes.present?
    end

    def telefono
      address_attributes["numero_convencional"] if address_attributes.present?
    end

    def customer_order_delivery
      resource
    end

    def card_attributes
      [
        :created_at,
        :address,
        :courier_profile,
        :customer_order_delivery,
        :estimated_time_for_delivery,
        :telefono
      ]
    end

    def detail_attributes
      card_attributes + [
        :reason,
        :delivery_location
      ]
    end
  end
end
