json.customer_order do
  json.partial!(
    "api/customer/customer_orders/customer_order",
    customer_order: @api_resource
  )
end
