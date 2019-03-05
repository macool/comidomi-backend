json.shipping_request do
  shipping_request = customer_order_delivery.shipping_request

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
