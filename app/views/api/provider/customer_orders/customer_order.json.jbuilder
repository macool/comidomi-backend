json.customer_order do
  json.partial!(
    "customer_order",
    customer_order: @api_resource
  )
end
