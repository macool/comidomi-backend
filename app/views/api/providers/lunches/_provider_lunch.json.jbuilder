json.extract!(
  provider_lunch,
  :id,
  :precio_cents
)

json.lunch_items do
  json.array!(
    provider_lunch.lunch_items,
    partial: "api/providers/lunches/provider_lunch_item",
    as: :provider_lunch_item
  )
end
