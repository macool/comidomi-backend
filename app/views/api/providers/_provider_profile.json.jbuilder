# public provider profile

json.extract!(
  provider_profile.decorate,
  :id,
  :ruc,
  :status,
  :razon_social,
  :nombre_establecimiento,
  :actividad_economica,
  :representante_legal,
  :telefono,
  :email,
  :website,
  :formas_de_pago,
  :logotipo_url,
  :logotipo_thumbnail_url,
  :facebook_handle,
  :twitter_handle,
  :instagram_handle,
  :youtube_handle,
  :cover_url
)
