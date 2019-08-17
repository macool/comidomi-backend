class ProviderLunch < ActiveRecord::Base
  belongs_to :provider_profile

  monetize :precio_cents,
           numericality: false

  validates :precio, numericality: { greater_than: 0 }
end
