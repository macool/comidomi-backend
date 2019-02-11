json.shipping_requests do
  json.array!(
    @api_collection,
    partial: "shipping_request",
    as: :shipping_request
  )
end
