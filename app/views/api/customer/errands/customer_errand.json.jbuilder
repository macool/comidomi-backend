json.customer_errand do
  json.extract!(
    @api_resource.customer_errand,
    :id,
    :description
  )
end
