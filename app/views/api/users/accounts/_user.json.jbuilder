json.extract!(
  user.decorate,
  :id,
  :uid,
  :name,
  :info,
  :image,
  :email,
  :ciudad,
  :nickname,
  :provider,
  :custom_image_url,
  :agreed_tos,
  :current_place_id,
  :phone_number
)
json.fecha_nacimiento(
  l(user.fecha_nacimiento, format: :api)
) if user.fecha_nacimiento.present?

if user.current_place.present?
  json.current_place do
    json.partial!(
      "api/users/places/place",
      place: user.current_place.decorate
    )
  end
end
