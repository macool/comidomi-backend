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
    attrs = [
      :provider_item_category
    ]
    attrs.unshift(
      :precio_str,
      :en_stock
    ) unless object.is_group?
    if object.parent_provider_item.present?
      attrs.unshift(:parent_provider_item_str_with_link)
    end
    if object.is_promo?
      attrs.push(:promo_weekdays)
    end
    attrs
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

  def precio_str
    h.humanized_money_with_symbol object.precio
  end

  def en_stock
    object.en_stock ? h.t("ui.positive") : h.t("ui.negative")
  end

  def created_at
    h.l(object.created_at, format: :admin_full)
  end

  def children_items
    @children_items ||= object.class.with_parent_id(object.id)
  end

  def parent_provider_item_str_with_link
    h.link_to(
      parent_provider_item.titulo,
      h.admin_provider_item_path(object.parent_provider_item)
    )
  end

  def promo_weekdays
    weekdays.available.map do |wday|
      h.t("enumerize.defaults.daynames.#{wday.wkday}")
    end.join(", ")
  end
end
