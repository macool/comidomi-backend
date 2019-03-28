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
#

class CustomerErrand < ActiveRecord::Base
  belongs_to :place
  belongs_to :customer_profile
  belongs_to :customer_address

  validates :customer_profile,
            :place,
            :description,
            :customer_address,
            presence: true

  def shipping_fare=(new_shipping_fare)
    self.shipping_fare_price_cents = new_shipping_fare.price_cents
    self.shipping_fare_price_currency = new_shipping_fare.price_currency
  end
end
