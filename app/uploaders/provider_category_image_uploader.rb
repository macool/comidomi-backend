# encoding: utf-8
class ProviderCategoryImageUploader < ImageVersionableUploader
  def default_url
    uri = "/images/provider_category/defaults/" + model.titulo.parameterize + ".jpg"
    asset_host + uri
  end
end
