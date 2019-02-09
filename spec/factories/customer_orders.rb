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

FactoryGirl.define do
  factory :customer_order do
    customer_profile

    status :in_progress # default
    place {
      if customer_profile && customer_profile.user
        customer_profile.user.current_place
      else
        build :place
      end
    }

    trait :with_order_item do
      after(:create) do |customer_order|
        create :customer_order_item,
               :ready_for_checkout,
               customer_order: customer_order
      end
    end

    trait :with_customer_billing_address do
      after(:create) do |customer_order|
        customer_order.customer_billing_address = create(
          :customer_billing_address,
          customer_profile: customer_order.customer_profile
        )
      end
    end

    trait :submitted do
      status :submitted
      submitted_at { Time.now }
    end
  end
end
