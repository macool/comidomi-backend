json.partial!(
  "api/customer/customer_orders/customer_order_detail",
  customer_order: customer_order
)

json.provider_profiles do
  json.array! [current_provider_profile] do |provider_profile|
    json.partial!(
      "api/customer/cart/provider_profiles",
      provider_profile: provider_profile,
      customer_order: customer_order
    )
  end
end
