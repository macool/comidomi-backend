json.customer_resources do
  json.array! @api_collection do |customer_resource|
    json.partial!(
      "customer_resource",
      customer_resource: customer_resource
    )
  end
end
