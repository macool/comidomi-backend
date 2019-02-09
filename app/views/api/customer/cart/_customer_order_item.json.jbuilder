json.extract!(
  customer_order_item,
  :id,
  :cantidad,
  :observaciones
)

json.provider_item_precio_cents customer_order_item.provider_item_precio.cents
json.provider_item_precio_currency customer_order_item.provider_item_precio.currency.iso_code

json.provider_item do
  json.partial!(
    "api/providers/items/provider_item",
    provider_item: customer_order_item.provider_item
  )
end
