# == Schema Information
#
# Table name: shipping_requests
#
#  id                  :integer          not null, primary key
#  resource_id         :integer          not null
#  resource_type       :string           not null
#  kind                :string           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  status              :string           default("new"), not null
#  address_attributes  :json
#  courier_profile_id  :integer
#  reason              :string
#  place_id            :integer          not null
#  waypoints           :json
#  estimated_time_mins :integer
#  assigned_at         :datetime
#  ref_lat             :float            not null
#  ref_lon             :float            not null
#  confirmed_at        :datetime
#

FactoryGirl.define do
  factory :shipping_request do
    resource { build :provider_profile }
    kind     { ShippingRequest.kind.values.first }
    place {
      Place.first.presence || build(:place)
    }

    trait :for_customer_order_delivery do
      kind :customer_order_delivery
      resource { create :customer_order_delivery }
    end

    trait :with_address_attributes do
      address_attributes {
        {
          lat: Faker::Address.latitude,
          lon: Faker::Address.longitude,
          direccion: Faker::Address.street_address
        }
      }
    end

    trait :assigned_to_courier do
      status :assigned
      courier_profile
    end
  end
end
