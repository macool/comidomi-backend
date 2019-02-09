# == Schema Information
#
# Table name: provider_item_categories
#
#  id                  :integer          not null, primary key
#  nombre              :string
#  predeterminada      :boolean          default(FALSE)
#  provider_profile_id :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class ProviderItemCategory < ActiveRecord::Base
  has_paper_trail

  belongs_to :provider_profile
  has_many :provider_items

  scope :by_nombre, -> {
    order("LOWER(nombre)")
  }
  scope :nombre_like, ->(query) {
    where("nombre ILIKE :nombre", nombre: "%#{query}%")
  }

  def self.default
    where(predeterminada: true).first
  end

  def personal
    provider_profile_id.present?
  end
end
