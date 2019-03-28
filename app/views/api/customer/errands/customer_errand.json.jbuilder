json.customer_errand do
  json.extract!(
    @api_resource.customer_errand,
    :id,
    :description,
    :customer_address_id,
    :shipping_fare_price_cents,
    :shipping_fare_price_currency
  )
end
