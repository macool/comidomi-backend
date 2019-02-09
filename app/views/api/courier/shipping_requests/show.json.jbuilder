json.shipping_request do
  json.partial!(
    "shipping_request",
    shipping_request: @api_resource
  )
end
