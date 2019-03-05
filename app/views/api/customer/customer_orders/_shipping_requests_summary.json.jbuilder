json.shipping_requests do
  json.array! customer_order.deliveries do |customer_order_delivery|
    shipping_request = customer_order_delivery.shipping_request
    provider_profile = customer_order_delivery.provider_profile

    json.provider_name provider_profile.nombre_establecimiento

    if shipping_request.present?
      json.status shipping_request.status

      if shipping_request.courier_profile.present?
        json.courier_profile do
          json.extract!(
            shipping_request.courier_profile,
            :id,
            :nombres
          )
        end
      end
    end
  end
end
