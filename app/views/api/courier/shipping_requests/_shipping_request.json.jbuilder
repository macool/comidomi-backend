json.partial!(
  "api/courier/shipping_requests/shipping_request_details",
  shipping_request: shipping_request
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

if shipping_request.kind.customer_errand?
  json.customer_errand do
    json.partial!(
      "api/customer/errands/customer_errand",
      customer_errand: shipping_request.resource
    )
  end

  json.customer_order do
    json.customer_profile do
      json.partial!(
        "api/customer/customer_orders/customer_profile",
        customer_profile: shipping_request.resource.customer_profile
      )
    end

    # TODO: billing for errands
    # if shipping_request.resource.customer_billing_address.present?
    if false
      json.customer_billing_address do
        json.partial!(
          "api/customer/billing_addresses/billing_address",
          billing_address: shipping_request.resource.customer_billing_address
        )
      end
    end
  end
end
