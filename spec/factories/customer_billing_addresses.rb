# == Schema Information
#
# Table name: customer_billing_addresses
#
#  id                  :integer          not null, primary key
#  customer_profile_id :integer          not null
#  ciudad              :string
#  telefono            :string
#  email               :string
#  ruc                 :string           not null
#  razon_social        :string           not null
#  direccion           :string           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

FactoryGirl.define do
  factory :customer_billing_address do
    customer_profile

    ruc          { Faker::Code.ean }
    email        { Faker::Internet.email }
    ciudad       { Faker::Address.city }
    telefono     { Faker::PhoneNumber.phone_number }
    direccion    { Faker::Address.street_address }
    razon_social { Faker::Company.name }
  end
end
