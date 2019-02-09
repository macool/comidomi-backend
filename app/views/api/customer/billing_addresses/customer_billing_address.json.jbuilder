json.customer_billing_address do
  json.partial!(
    "billing_address",
    billing_address: @api_resource
  )
end
