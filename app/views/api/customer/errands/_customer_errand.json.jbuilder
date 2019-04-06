json.extract!(
  customer_errand,
  :id,
  :description,
  :customer_address_id,
  :shipping_fare_price_cents,
  :shipping_fare_price_currency
)

json.kind customer_errand.class.to_s.underscore
