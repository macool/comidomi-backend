json.extract!(
  product,
  :id,
  :titulo,
  :descripcion,
  :unidad_medida,
  :precio_cents,
  :volumen,
  :peso,
  :observaciones,
  :created_at,
  :updated_at
)

json.imagenes do
  json.array!(
    product.imagenes,
    partial: "api/providers/items/provider_item_image",
    as: :provider_item_image
  )
end
