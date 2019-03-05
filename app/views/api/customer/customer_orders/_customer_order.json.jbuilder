json.partial!(
  "api/customer/customer_orders/customer_order_detail",
  customer_order: customer_order
)

json.provider_profiles do
  json.array! customer_order.provider_profiles do |provider_profile|
    json.partial!(
      "api/customer/cart/provider_profiles",
      provider_profile: provider_profile,
      customer_order: customer_order
    )
  end
end

if customer_order.status.submitted?
  json.partial!(
    "api/customer/customer_orders/shipping_requests_summary",
    customer_order: customer_order
  )
end
