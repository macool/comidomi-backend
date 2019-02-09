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

FactoryGirl.define do
  factory :shipping_fare do
    place
    price_cents 150
  end
end
