# == Schema Information
#
# Table name: shipping_fares
#
#  id             :integer          not null, primary key
#  place_id       :integer          not null
#  price_cents    :integer          default(0), not null
#  price_currency :string           default("USD"), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class ShippingFare < ActiveRecord::Base
  has_paper_trail

  belongs_to :place

  validates :place_id,
            :price_cents,
            presence: true
  validates :price_cents,
            numericality: { greater_than: 0 }

  monetize :price_cents

  before_validation :set_place_currency!

  scope :for_place, ->(place) { where(place: place) }
  scope :smaller, ->{
    order(price_cents: :asc)
  }
  scope :bigger, ->{
    order(price_cents: :desc)
  }
  scope :by_ceil_price_cents, ->(price_cents){
    where(
      "price_cents > :price_cents",
      price_cents: price_cents
    )
  }

  def set_place_currency!
    self.price_currency = place.currency_iso_code
  end
end
