class ProviderCategoryDecorator < GenericResourceDecorator
  def to_s
    titulo
  end

  def card_attributes
    [:titulo, :descripcion]
  end

  def imagen_url
    imagen.file.nil? ? object.imagen_url : imagen.big.url
  end
end
