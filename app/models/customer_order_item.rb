# == Schema Information
#
# Table name: customer_order_items
#
#  id                            :integer          not null, primary key
#  customer_order_id             :integer          not null
#  provider_item_id              :integer          not null
#  provider_item_precio_cents    :integer
#  provider_item_precio_currency :string           default("USD"), not null
#  cantidad                      :integer          default(1), not null
#  observaciones                 :text
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#

class CustomerOrderItem < ActiveRecord::Base
  monetize :provider_item_precio_cents,
           numericality: false,
           allow_nil: true

  begin :relationships
    belongs_to :customer_order
    belongs_to :provider_item
  end

  begin :callbacks
    after_save :update_customer_order_subtotals!
    after_save :create_customer_order_delivery_if_necessary!
    after_destroy :update_customer_order_subtotals!
    after_destroy :destroy_customer_order_delivery_if_necessary!
  end

  begin :validations
    validates :cantidad,
              numericality: {
                greater_than: 0,
                only_integer: true
              }

    validates :provider_item_precio_cents,
              allow_nil: true,
              numericality: {
                greater_than: 0
              }
    validate :valid_provider_item_qty
  end

  ##
  # @return [Money]
  def subtotal
    cantidad * provider_item_precio
  end

  ##
  # reads cached provider_item_precio if present
  # or asks the provider_item otherwise
  # @return [Money]
  def provider_item_precio
    cached_precio = read_attribute(:provider_item_precio_cents)
    if cached_precio.present?
      Money.new(
        cached_precio,
        provider_item_precio_currency # DB defaults it to USD
      )
    else
      provider_item.precio
    end
  end

  ##
  # re-adds this customer order item to the cart
  # including new attributes
  def readd_from_attributes(parameters)
    self.cantidad += parameters[:cantidad].to_i
    if parameters[:observaciones].present?
      self.observaciones =
        self.observaciones.to_s + "\n" + parameters[:observaciones]
    end
  end

  def cache_provider_item_precio!
    update_attribute(
      :provider_item_precio,
      provider_item.precio
    )
  end

  def update_customer_order_subtotals!
    customer_order.cache_subtotal_items!
  end

  def create_customer_order_delivery_if_necessary!
    if customer_order_delivery.blank?
      customer_order.deliveries.create!(
        delivery_method: "shipping",
        customer_order: customer_order,
        provider_profile: provider_item.provider_profile,
        customer_address: customer_order.customer_profile.customer_addresses.first
      )
    end
  end

  def destroy_customer_order_delivery_if_necessary!
    items_for_current_provider = customer_order.order_items_by_provider(
      provider_item.provider_profile
    )
    if items_for_current_provider.none?
      customer_order_delivery.destroy
    end
  end

  def customer_order_delivery
    customer_order.delivery_for_provider(
      provider_item.provider_profile
    )
  end

  private

  def valid_provider_item_qty
    if cantidad > provider_item.cantidad
      errors.add(:cantidad, :less_than_or_equal_to_is, count: provider_item.cantidad, num: cantidad)
    end
  end
end
