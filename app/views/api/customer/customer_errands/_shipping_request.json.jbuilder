json.shipping_request do
  json.partial!(
    "api/courier/shipping_requests/shipping_request_details",
    shipping_request: customer_errand.shipping_request
  )
end
