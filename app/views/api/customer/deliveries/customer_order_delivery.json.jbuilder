json.customer_order_delivery do
  json.partial!(
    "api/customer/customer_order_deliveries/customer_order_delivery",
    order_delivery: @api_resource
  )
end
