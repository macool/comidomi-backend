# == Schema Information
#
# Table name: places
#
#  id                  :integer          not null, primary key
#  lat                 :string
#  lon                 :string
#  nombre              :string           not null
#  country             :string           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  price_per_km_cents  :integer          default(1)
#  factor_per_distance :float            default(0.1)
#  enabled             :boolean          default(FALSE)
#

class Place < ActiveRecord::Base
  has_paper_trail

  validates :nombre,
            :country,
            presence: true

  has_many :shipping_fares
  # here only to honour relationships
  has_many :users
  has_many :customer_orders
  has_many :courier_profiles
  has_many :provider_profiles

  scope :enabled, ->{ where(enabled: true) }
  scope :sorted, ->{
    order(:country, :nombre)
  }

  def to_s
    "#{nombre}, #{country}"
  end

  def currency_iso_code
    ISO3166::Country.find_country_by_name(country).currency.iso_code
  end

  def self.default
    where(nombre: 'Loja').first
  end
end
