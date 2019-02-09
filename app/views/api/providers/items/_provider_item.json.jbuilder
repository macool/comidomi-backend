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
  :provider_profile_id
)

json.imagenes do
  json.array!(
    provider_item.imagenes,
    partial: "api/providers/items/provider_item_image",
    as: :provider_item_image
  )
end
