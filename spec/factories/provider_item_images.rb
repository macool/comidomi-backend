# == Schema Information
#
# Table name: provider_item_images
#
#  id               :integer          not null, primary key
#  provider_item_id :integer          not null
#  imagen           :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

FactoryGirl.define do
  factory :provider_item_image do
    provider_item

    imagen {
      File.open(Rails.root.join("spec/fixtures/placeholder.png"))
    }
  end
end
