json.extract!(
  shipping_request,
  :id,
  :kind,
  :kind_text,
  :status,
  :address_attributes,
  :waypoints,
  :estimated_time_mins,
  :assigned_at,
  :estimated_delivery_at,
  :estimated_dispatch_at,
  :ref_lat,
  :ref_lon
)

if shipping_request.kind.ask_to_validate?
  json.provider_profile do
    json.partial!(
      "api/providers/provider_profile",
      provider_profile: shipping_request.resource
    )
  end
end

if shipping_request.kind.customer_order_delivery?
  customer_order = shipping_request.resource.customer_order
  provider_profile = shipping_request.resource.provider_profile
  json.provider_profile do
    json.partial!(
      "api/providers/provider_profile",
      provider_profile: provider_profile
    )
  end

  json.customer_order_delivery do
    json.partial!(
      "api/customer/customer_order_deliveries/customer_order_delivery",
      order_delivery: shipping_request.resource
    )
  end

  json.customer_order do
    json.partial!(
      "api/customer/customer_orders/customer_order_detail",
      customer_order: customer_order
    )

    json.customer_order_items do
      json.array!(
        customer_order.order_items_by_provider(provider_profile),
        partial: "api/customer/cart/customer_order_item",
        as: :customer_order_item
      )
    end
  end
end
