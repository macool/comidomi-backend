json.extract!(
  customer_errand,
  :id,
  :description,
  :customer_address_id,
  :shipping_fare_price_cents,
  :shipping_fare_price_currency,
  :created_at,
  :status
)

json.kind customer_errand.class.to_s.underscore
json.customer_address_attributes do
  json.extract!(
    customer_errand.customer_address,
    :id,
    :ciudad,
    :parroquia,
    :barrio,
    :direccion_uno,
    :direccion_dos,
    :codigo_postal,
    :referencia,
    :numero_convencional,
    :nombre,
    :lat,
    :lon
  )
end
