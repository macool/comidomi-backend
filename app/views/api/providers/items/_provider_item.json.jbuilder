json.extract!(
  provider_item,
  :id,
  :titulo,
  :descripcion,
  :unidad_medida,
  :precio_cents,
  :precio_currency,
  :volumen,
  :peso,
  :observaciones,
  :cantidad,
  :provider_item_category_id,
  :provider_profile_id,
  :is_group
)

json.imagenes do
  json.array!(
    provider_item.imagenes,
    partial: "api/providers/items/provider_item_image",
    as: :provider_item_image
  )
end

if provider_item.is_group?
  json.children do
    json.array!(
      provider_item.children_provider_items,
      partial: "/api/providers/items/provider_item",
      as: :provider_item
    )
  end
end
