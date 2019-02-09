# == Schema Information
#
# Table name: provider_clients
#
#  id                  :integer          not null, primary key
#  provider_profile_id :integer
#  notas               :text
#  ruc                 :string
#  nombres             :string
#  direccion           :string
#  telefono            :string
#  email               :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  deleted_at          :datetime
#

FactoryGirl.define do
  factory :provider_client do
    provider_profile

    notas        { Faker::Company.catch_phrase }
    ruc          { Faker::Code.isbn }
    nombres      { Faker::Company.name }
    direccion    { Faker::Address.street_address }
    telefono     { Faker::PhoneNumber.phone_number }
    email        { Faker::Internet.email }
  end
end
