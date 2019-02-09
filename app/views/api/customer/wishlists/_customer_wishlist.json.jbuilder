json.extract!(
  customer_wishlist,
  :id,
  :nombre
)

json.entregar_en(
  l(customer_wishlist.entregar_en, format: :api)
) if customer_wishlist.entregar_en.present?

json.provider_items do
  json.array!(
    customer_wishlist.provider_items,
    partial: "provider_item",
    as: :provider_item
  )
end
