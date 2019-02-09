# == Schema Information
#
# Table name: provider_categories
#
#  id          :integer          not null, primary key
#  titulo      :string           not null
#  imagen      :string
#  descripcion :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  status      :string           default("enabled"), not null
#

FactoryGirl.define do
  factory :provider_category do
    titulo      { Faker::Commerce.department(1) }
    imagen      { Faker::Avatar.image(nil, "400x600") }
    descripcion { Faker::Hipster.sentence }
  end
end
