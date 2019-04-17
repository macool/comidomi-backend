# == Schema Information
#
# Table name: provider_items
#
#  id                        :integer          not null, primary key
#  provider_profile_id       :integer
#  titulo                    :string           not null
#  descripcion               :text
#  unidad_medida             :integer
#  precio_cents              :integer          default(0), not null
#  precio_currency           :string           default("USD"), not null
#  volumen                   :string
#  peso                      :string
#  observaciones             :text
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  deleted_at                :datetime
#  cantidad                  :integer          default(0)
#  en_stock                  :boolean
#  provider_item_category_id :integer
#  parent_provider_item_id   :integer
#  is_group                  :boolean          default(FALSE)
#

class ProviderItem < ActiveRecord::Base
  has_paper_trail

  include SoftDestroyable

  UNIDADES_MEDIDA = [
    "volumen",
    "unidades",
    "peso",
    "longitud"
  ].freeze

  enum unidad_medida: UNIDADES_MEDIDA

  monetize :precio_cents,
           numericality: false

  begin :validations
    validates :titulo,
              :cantidad,
              presence: true
    validates :precio,
              numericality: { greater_than: 0 },
              unless: :is_group?
    validates :cantidad,
              numericality: { greater_than_or_equal_to: 0 }
    validates :unidad_medida,
              inclusion: { in: UNIDADES_MEDIDA }
    validates :provider_profile_id,
              presence: true
    validate :validate_currency_is_allowed,
             if: "provider_profile.status.active?"
  end

  begin :scopes
    scope :in_stock, ->{ where(en_stock: true) }
    scope :available, ->{ where("cantidad > 0") }
    scope :by_titulo, ->{ order(:titulo) }
    scope :groups, ->{ where(is_group: true) }
    scope :by_price, ->{ order(:precio_cents) }
    scope :with_parent_id,
          ->(parent_id) { where(parent_provider_item_id: parent_id) }
    scope :in_stock_and_available_or_group,
          ->{ where("(en_stock = 't' AND cantidad > 0 AND parent_provider_item_id IS NULL) OR (is_group = 't')") }
  end

  begin :callbacks
    before_update :touch_if_associations_changed
  end

  begin :relationships
    belongs_to :provider_profile
    belongs_to :provider_item_category
    belongs_to :parent_provider_item,
               class_name: "ProviderItem"
    has_many :imagenes,
             class_name: 'ProviderItemImage',
             dependent: :destroy
    has_many :children_provider_items,
             -> { by_price },
             class_name: "ProviderItem",
             foreign_key: :parent_provider_item_id

    accepts_nested_attributes_for(
      :imagenes,
      allow_destroy: true,
      reject_if: proc { |attrs|
        attrs['imagen'].blank? && attrs['_destroy'].blank?
      }
    )

    accepts_nested_attributes_for(
      :provider_item_category,
      reject_if: proc { |attrs| attrs['nombre'].blank? }
    )
  end

  private

  def validate_currency_is_allowed
    unless provider_profile.allowed_currency_iso_codes.include?(precio_currency)
      errors.add(:precio_currency, :invalid_currency)
    end
  end

  def touch_if_associations_changed
    if imagenes.any?(&:changed?) || imagenes.any?(&:marked_for_destruction?)
      # touch_with_version
      self.updated_at = Time.now
    end
  end
end
