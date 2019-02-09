# == Schema Information
#
# Table name: customer_orders
#
#  id                                  :integer          not null, primary key
#  status                              :string           default("in_progress"), not null
#  subtotal_items_cents                :integer          default(0), not null
#  subtotal_items_currency             :string           default("USD"), not null
#  customer_profile_id                 :integer          not null
#  created_at                          :datetime         not null
#  updated_at                          :datetime         not null
#  forma_de_pago                       :string
#  observaciones                       :text
#  customer_billing_address_attributes :text
#  customer_billing_address_id         :integer
#  submitted_at                        :datetime
#  anon_billing_address                :boolean          default(FALSE)
#  place_id                            :integer
#

class CustomerOrder < ActiveRecord::Base
  extend Enumerize

  has_paper_trail unless: Proc.new { |customer_order|
    customer_order.status.in_progress?
  }

  STATUSES = [
    "in_progress",
    "submitted"
  ].freeze
  FORMAS_DE_PAGO = [
    "efectivo"
  ].freeze

  enumerize :status,
            in: STATUSES,
            default: :in_progress,
            scope: true,
            i18n_scope: "customer_order.status"
  enumerize :forma_de_pago,
            in: FORMAS_DE_PAGO

  monetize :subtotal_items_cents,
           numericality: false

  validates :status,
            inclusion: { in: STATUSES }
  validates :forma_de_pago,
            allow_nil: true,
            inclusion: { in: FORMAS_DE_PAGO }
  validates :customer_billing_address,
            own_address: true
  validate :validate_anon_without_billing_address

  belongs_to :place
  belongs_to :customer_profile
  belongs_to :customer_address
  belongs_to :customer_billing_address
  has_many :deliveries,
           class_name: "CustomerOrderDelivery"
  # TODO should this be through deliveries?
  has_many :order_items,
           class_name: "CustomerOrderItem",
           dependent: :destroy

  accepts_nested_attributes_for :deliveries

  begin :scopes
    scope :latest, -> {
      order(created_at: :desc)
    }
    scope :for_place, ->(place) {
      where(place: place)
    }
  end

  serialize :customer_billing_address_attributes, JSON

  ##
  # caches subtotal_items
  def cache_subtotal_items!
    # HACK: force reloading order_items so they're fresh
    # see spec/models/customer_order_spec
    order_items.reload

    update_attribute(
      :subtotal_items,
      order_items.collect(&:subtotal).sum
    )
  end

  ##
  # @note if order is in progress providers are
  #   filtered by user location. submitted orders
  #   should not need filtering
  def provider_profiles
    ProviderProfile.where(
      id: provider_profile_ids
    )
  end

  def provider_profile_ids
    provider_items.pluck(:provider_profile_id)
  end

  def provider_items
    ProviderItem.where(
      id: order_items.pluck(:provider_item_id)
    )
  end

  def order_items_by_provider(provider_profile)
    order_items.includes(provider_item: :imagenes)
               .select do |order_item|
      order_item.provider_item.provider_profile_id == provider_profile.id
    end
  end

  def delivery_for_provider(provider_profile)
    deliveries.detect do |delivery|
      delivery.provider_profile_id == provider_profile.id
    end
  end

  private

  def validate_anon_without_billing_address
    if anon_billing_address? && customer_billing_address_id.present?
      errors.add(:anon_billing_address, :includes_billing_address)
      errors.add(:customer_billing_address_id, :is_anon_billing)
    end
  end
end
