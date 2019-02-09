json.customer_address do
  json.partial!(
    "address",
    customer_address: @api_resource.decorate
  )
end
