class ProviderItemCategoryDecorator < Draper::Decorator
  delegate_all
  decorates_association :provider_profile

  def to_s
    nombre
  end

  def admin_link_to_resource(options=nil, &block)
    h.link_to h.admin_provider_item_categories_path, options, &block
  end
end
