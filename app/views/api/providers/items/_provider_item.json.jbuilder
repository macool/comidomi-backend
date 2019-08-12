json.extract!(
  provider_item,
  :id,
  :titulo,
  :descripcion,
  :unidad_medida,
  :precio_currency,
  :volumen,
  :peso,
  :observaciones,
  :cantidad,
  :provider_item_category_id,
  :provider_profile_id,
  :is_group,
  :is_promo
)

precio_cents = if provider_item.is_group?
  provider_item.children_provider_items.map(&:precio_cents).min
else
  provider_item.precio_cents
end

nombre_de_categoria = if provider_item.provider_item_category
  provider_item.provider_item_category.nombre
end

json.set! :precio_cents, precio_cents
json.set! :nombre_de_categoria, nombre_de_categoria

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

if provider_item.is_promo?
  json.weekdays do
    json.array!(
      provider_item.weekdays,
      partial: "/api/providers/items/weekday",
      as: :weekday
    )
  end
end
