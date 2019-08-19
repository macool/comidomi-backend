class ProviderLunchDecorator < GenericResourceDecorator
  decorates_association :provider_profile

  def card_attributes
    [
      :precio_str
    ]
  end

  def precio_str
    h.humanized_money_with_symbol precio
  end

  def admin_link_to_resource(options=nil, &block)
    h.link_to(
      h.admin_provider_lunch_path(object),
      options,
      &block
    )
  end

  def titulo
    I18n.l(created_at, format: "%A %e %b '%y")
  end

  def lunch_items_by_kind
    lunch_items.inject({}) do |memo, lunch_item|
      memo[lunch_item.kind] ||= []
      memo[lunch_item.kind].push lunch_item
      memo
    end
  end
end
