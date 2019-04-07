# == Schema Information
#
# Table name: customer_errands
#
#  id                           :integer          not null, primary key
#  customer_profile_id          :integer          not null
#  place_id                     :integer          not null
#  description                  :text             not null
#  customer_address_id          :integer          not null
#  shipping_fare_price_cents    :integer          default(0), not null
#  shipping_fare_price_currency :string           default("USD"), not null
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  status                       :string           default("in_progress"), not null
#

class CustomerErrand < ActiveRecord::Base
  extend Enumerize

  STATUSES = [
    :in_progress,
    :delivered,
    :canceled
  ].freeze

  enumerize :status,
            in: STATUSES,
            default: :in_progress,
            scope: true,
            i18n_scope: "customer_errand.status"

  belongs_to :place
  belongs_to :customer_profile
  belongs_to :customer_address

  validates :customer_profile,
            :place,
            :description,
            :customer_address,
            presence: true

  scope :latest, -> {
    order(created_at: :desc)
  }

  def shipping_fare=(new_shipping_fare)
    self.shipping_fare_price_cents = new_shipping_fare.price_cents
    self.shipping_fare_price_currency = new_shipping_fare.price_currency
  end
end
