json.customer_errand do
  json.partial!(
    "customer_errand",
    customer_errand: @api_resource.customer_errand
  )
end
