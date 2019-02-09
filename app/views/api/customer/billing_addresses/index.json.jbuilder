json.customer_billing_addresses do
  json.array!(
    @api_collection,
    partial: "billing_address",
    as: :billing_address
  )
end
