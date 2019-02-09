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

class ProviderCategory < ActiveRecord::Base
  extend Enumerize

  has_paper_trail

  validates :titulo,
            presence: true,
            uniqueness: true
  has_many :provider_profiles
  mount_uploader :imagen, ProviderCategoryImageUploader

  enumerize :status,
            in: [:enabled, :disabled].freeze,
            scope: true,
            i18n_scope: "provider_category.statuses"

  scope :by_titulo, -> { order(:titulo) }
end
