# == Schema Information
#
# Table name: provider_profiles
#
#  id                     :integer          not null, primary key
#  user_id                :integer
#  ruc                    :string
#  razon_social           :string
#  actividad_economica    :string
#  tipo_contribuyente     :string
#  representante_legal    :string
#  telefono               :string
#  email                  :string
#  fecha_inicio_actividad :date
#  banco_nombre           :string
#  banco_numero_cuenta    :string
#  website                :string
#  facebook_handle        :string
#  twitter_handle         :string
#  instagram_handle       :string
#  youtube_handle         :string
#  formas_de_pago         :text             default([]), is an Array
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  provider_category_id   :integer
#  nombre_establecimiento :string           not null
#  logotipo               :string
#  banco_tipo_cuenta      :integer
#  status                 :integer          default(0)
#  cover                  :string
#

class ProviderProfile < ActiveRecord::Base
  extend Enumerize
  extend IntegersEnumerable

  FORMAS_DE_PAGO = [
    "efectivo",
    "tarjeta_credito"
  ].freeze
  BANCO_TIPOS_CUENTA = [
    "Ahorros",
    "Crédito"
  ].freeze
  STATUSES = integers_enumerable([
    :applied, # just applied
    :ask_to_validate, # awaiting contract with provider
    :validated, # accepted by customer service
    :active, # enabled by admin - provider ready to sell
    :for_testing, # provider available for testers only
    :ask_to_disable, # awaiting admin to confirm and disable
    :disabled # disabled by admin
  ])

  has_paper_trail

  attr_accessor :generate_user

  enum banco_tipo_cuenta: BANCO_TIPOS_CUENTA
  enumerize :status,
            in: STATUSES,
            scope: true,
            i18n_scope: "provider_profile.statuses"

  mount_uploader :logotipo, ProviderProfileLogotipoUploader
  mount_uploader :cover, ProviderProfileCoverUploader

  begin :relationships
    belongs_to :user
    belongs_to :provider_category
    has_many :provider_items
    has_many :provider_clients
    has_many :provider_item_categories
    has_many :offices,
             class_name: 'ProviderOffice',
             dependent: :destroy

    accepts_nested_attributes_for(
      :offices,
      reject_if: proc { |attrs| attrs['direccion'].blank? && attrs["weekdays_attributes"].blank? }
    )
  end

  begin :validations
    validates :ruc,
              :email,
              :telefono,
              :razon_social,
              :representante_legal,
              :nombre_establecimiento,
              presence: true
    validates :ruc,
              :email,
              uniqueness: true
    validates :provider_category_id,
              presence: true,
              unless: "status.applied? && paper_trail_event != 'apply'"
    validate :validate_formas_de_pago
  end

  begin :scopes
    scope :by_nombre, -> {
      order(:nombre_establecimiento)
    }
    scope :for_active_provider_categories, ->{
      where(provider_category_id: ProviderCategory.with_status(:enabled).pluck(:id))
    }
    scope :with_enabled_offices_in, ->(place) {
      where(
        id: ProviderOffice.where(provider_profile_id: all.pluck(:id))
                          .for_place(place)
                          .enabled
                          .pluck(:provider_profile_id)
      )
    }
  end

  begin :callbacks
    before_create :generate_or_set_user_if_needed
    before_update :touch_if_associations_changed
  end

  ##
  # @note assigns default category to items without category
  def provider_items_by_categories(provider_items_scope)
    provider_items_scope.group_by do |provider_item|
        provider_item.provider_item_category || ProviderItemCategory.default
      end.map do |provider_item_category, provider_items|
        {
          provider_items: provider_items,
          provider_item_category: provider_item_category
        }
      end
  end

  def cover_provider_url
    if self.cover_url.present?
      self.cover_url
    else
      provider_category.imagen_url if provider_category.present?
    end
  end

  def allowed_currency_iso_codes
    offices.map(&:place).compact.map(&:currency_iso_code)
  end

  private

  ##
  # @note will reject! (inline) blank options
  def validate_formas_de_pago
    formas_de_pago.reject!(&:blank?)
    all_valid = formas_de_pago.all? do |forma_de_pago|
      FORMAS_DE_PAGO.include?(forma_de_pago)
    end
    errors.add(:formas_de_pago, :invalid) unless all_valid
    errors.add(:formas_de_pago, :empty) if formas_de_pago.empty?
  end

  def touch_if_associations_changed
    if offices.any?(&:changed?) || offices.any?(&:marked_for_destruction?)
      self.updated_at = Time.now
    end
  end

  def generate_or_set_user_if_needed
    if generate_user.present? && generate_user == "1"
      if User.exists?(email: email)
        self.user = User.find_by(email: email)
      else
        self.user = User.create!(
          email: email,
          name: representante_legal,
          password: Devise.friendly_token[0,20]
        )
      end
    end
  end
end
