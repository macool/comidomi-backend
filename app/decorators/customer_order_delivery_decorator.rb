class CustomerOrderDeliveryDecorator < GenericResourceDecorator
  decorates_association :provider_profile

  def card_attributes
    [
      :full_resume_for_card,
      :deliver_at,
      :shipping_request_desc
    ]
  end

  def detail_after_table_attributes
    [
      :deliver_at,
      :preparation_time_mins
    ]
  end

  def preparation_time_mins
    # TODO
    "#{object.preparation_time_mins} minutos" if object.status.accepted?
  end

  def full_resume_for_card
    "#{provider_profile} - ##{id} #{status_text} - #{delivery_method_text}"
  end

  def to_s
    full_resume_for_card
  end

  def order_items
    customer_order.order_items_by_provider(
      provider_profile.object
    ).map(&:decorate)
  end

  def subtotal_items
    order_items.inject(0) do |sum, order_item|
      sum + order_item.subtotal
    end
  end

  def deliver_at
    if object.deliver_at.present?
      h.l(object.deliver_at, format: :admin_full)
    end
  end

  def status_explanation
    h.t(
      "customer_order_delivery.status_explanation." + status
    )
  end

  def admin_link_to_resource(options=nil, &block)
    h.link_to h.admin_customer_order_path(customer_order),
              options,
              &block
  end

  def local_shipping_fare_price
    Money.new(
      object.shipping_fare_price_cents,
      object.customer_order.place.currency_iso_code
    )
  end

  def shipping_request_desc
    shipping_request.try :desc_label
  end

  def shipping_request
    @shipping_request ||= ShippingRequest.find_by(resource: object).try(:decorate)
  end
end
