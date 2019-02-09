class CustomerOrderDecorator < GenericResourceDecorator
  decorates_association :customer_profile
  decorates_association :deliveries

  def to_s
    h.t("activerecord.models.customer_order") + " ##{id}"
  end

  def card_attributes
    [
      :place,
      :submitted_at,
      :customer_profile,
      :subtotal_items
    ]
  end

  def detail_attributes
    card_attributes
  end

  def admin_link_to_resource(options=nil, &block)
    h.link_to(
      h.admin_customer_order_path(object),
      options,
      &block
    )
  end

  def submitted_at
    if object.submitted_at.present?
      h.l(object.submitted_at, format: :admin_full)
    end
  end

  def subtotal_items
    h.humanized_money_with_symbol object.subtotal_items
  end
end
