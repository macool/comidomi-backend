json.customer_addresses do
  json.array!(
    @api_collection,
    partial: "address",
    as: :customer_address
  )
end
