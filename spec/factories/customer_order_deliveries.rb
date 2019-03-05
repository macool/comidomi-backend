# == Schema Information
#
# Table name: customer_order_deliveries
#
#  id                          :integer          not null, primary key
#  deliver_at                  :datetime
#  delivery_method             :string           not null
#  customer_address_id         :integer
#  customer_address_attributes :json
#  provider_profile_id         :integer
#  customer_order_id           :integer          not null
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  status                      :string           default("draft"), not null
#  reason                      :text
#  shipping_fare_price_cents   :integer
#  preparation_time_mins       :integer
#  provider_responded_at       :datetime
#  dispatch_at                 :datetime
#

FactoryGirl.define do
  factory :customer_order_delivery do
    customer_order

    delivery_method "pickup"
    
    provider_profile { create :provider_profile, :with_office }

    trait :shipping do
      delivery_method "shipping"
      customer_address
    end

    trait :deliver_later do
      deliver_at { Time.now + 2.hours }
    end
  end
end
