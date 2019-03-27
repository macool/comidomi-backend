# a simplified version of the provider public profile

json.extract!(
  provider_profile.decorate,
  :id,
  :provider_category_id,
  :razon_social,
  :nombre_establecimiento,
  :actividad_economica,
  :logotipo_url,
  :logotipo_thumbnail_url,
  :cover_provider_url,
  :test_provider
)
