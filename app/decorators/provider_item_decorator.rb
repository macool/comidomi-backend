class ProviderItemDecorator < GenericResourceDecorator
  decorates_association :provider_profile
  decorates_association :provider_item_category

  def to_s
    titulo
  end

  def main_image_url
    if imagenes.any?
      imagenes.first.imagen.small_padded.url
    end
  end

  def placeholder_image
    h.content_tag :span,
                  nil,
                  class: "glyphicon glyphicon-picture placeholder-thumbnail"
  end

  def card_attributes
    [
      :precio,
      :en_stock,
      :provider_item_category
    ]
  end

  def detail_attributes
    card_attributes + [
      :descripcion,
      :observaciones,
      :unidad_medida,
      :volumen,
      :peso,
      :created_at,
      :cantidad
    ]
  end

  def admin_link_to_resource(options=nil, &block)
    h.link_to(
      h.admin_provider_item_path(object),
      options,
      &block
    )
  end

  def precio
    h.humanized_money_with_symbol object.precio
  end

  def en_stock
    object.en_stock ? h.t("ui.positive") : h.t("ui.negative")
  end

  def created_at
    h.l(object.created_at, format: :admin_full)
  end
end
