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

FactoryGirl.define do
  factory :customer_errand do
    customer_profile
    customer_address

    description { Faker::Hipster.paragraphs.join "\n" }

    place {
      if customer_profile && customer_profile.user
        customer_profile.user.current_place
      else
        build :place
      end
    }
  end
end
