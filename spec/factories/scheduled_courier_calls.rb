# == Schema Information
#
# Table name: scheduled_courier_calls
#
#  id                  :integer          not null, primary key
#  resource_id         :integer          not null
#  couriers_called_ids :text             default([]), is an Array
#  done                :boolean          default(FALSE)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  resource_type       :string           not null
#

FactoryGirl.define do
  factory :scheduled_courier_call do
    courier_profile nil
    customer_order nil
    couriers_called_ids "MyText"
  end
end
