json.partial!(
  "api/providers/provider_profile",
  provider_profile: provider_profile
)

json.customer_order_items do
  json.array!(
    customer_order.order_items_by_provider(provider_profile),
    partial: "api/customer/cart/customer_order_item",
    as: :customer_order_item
  )
end

order_delivery = customer_order.delivery_for_provider(provider_profile)
if order_delivery.present?
  json.customer_order_delivery do
    json.partial!(
      "api/customer/customer_order_deliveries/customer_order_delivery",
      order_delivery: order_delivery
    )

    if customer_order.status.submitted?
      json.partial!(
        "api/customer/customer_orders/shipping_requests_summary",
        customer_order: customer_order,
        customer_order_delivery: order_delivery
      )
    end
  end
end
