class ProviderItemImageDecorator < GenericResourceDecorator
  def admin_link_to_resource(options={}, &block)
    h.link_to(
      imagen_url,
      options.merge(target: "_blank"),
      &block
    )
  end

  def to_s
    imagen.file.filename
  end

  def imagen_url
    imagen.small_cropped.url
  end

  def thumbnail_url
    imagen.thumbnail_cropped.url
  end
end
