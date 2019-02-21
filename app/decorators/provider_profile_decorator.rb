class ProviderProfileDecorator < GenericResourceDecorator
  decorates_association :user
  decorates_association :offices
  decorates_association :provider_category

  def user_with_link
    user.str_with_link if user.present?
  end

  def places_with_links
    offices.map do |office|
      office.place.str_with_link if office.place.present?
    end.compact.uniq.join(", ").html_safe
  end

  def to_s
     nombre_establecimiento
  end

  def logotipo_url
    if object.logotipo?
      object.logotipo.small.url
    else
      h.gravatar_image_url(provider_profile.email)
    end
  end

  def formas_de_pago
    object.formas_de_pago.join(", ")
  end

  def admin_link_to_resource(options=nil, &block)
    h.link_to h.admin_provider_profile_path(object), options, &block
  end

  def card_attributes
    [
      :ruc,
      :razon_social,
      :actividad_economica,
      :user_with_link,
      :places_with_links
    ].freeze
  end

  def detail_attributes
    card_attributes + [
      :representante_legal,
      :tipo_contribuyente,
      :telefono,
      :email,
      :formas_de_pago,
      :fecha_inicio_actividad,
      :banco_nombre,
      :banco_numero_cuenta,
      :banco_tipo_cuenta,
      :website,
      :facebook_handle,
      :twitter_handle,
      :instagram_handle,
      :youtube_handle
    ].freeze
  end

  def test_provider
    object.status.for_testing?
  end
end
