# == Schema Information
#
# Table name: provider_lunches
#
#  id                  :integer          not null, primary key
#  provider_profile_id :integer          not null
#  precio_cents        :integer          default(0), not null
#  precio_currency     :string           default("USD"), not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class ProviderLunch < ActiveRecord::Base
  belongs_to :provider_profile
  has_many :lunch_items,
           class_name: "ProviderLunchItem",
           dependent: :destroy

  accepts_nested_attributes_for(
    :lunch_items,
    reject_if: proc { |attrs|
      attrs['name'].blank?
    }
  )

  monetize :precio_cents,
           numericality: false

  validates :precio, numericality: { greater_than: 0 }
end
