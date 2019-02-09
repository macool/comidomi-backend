# == Schema Information
#
# Table name: customer_addresses
#
#  id                  :integer          not null, primary key
#  ciudad              :string
#  parroquia           :string
#  barrio              :string
#  direccion_uno       :string
#  direccion_dos       :string
#  codigo_postal       :string
#  referencia          :text
#  numero_convencional :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  customer_profile_id :integer          not null
#  nombre              :string
#  lat                 :string           not null
#  lon                 :string           not null
#

class CustomerAddress < ActiveRecord::Base
  belongs_to :customer_profile

  before_save :set_default_nombre, if: "nombre.blank?"

  validates :lat,
            :lon,
            presence: {
              message: I18n.t("activerecord.errors.models.customer_address.required_location")
            }
  validates :direccion_uno, presence: true

  private

  def set_default_nombre
    self.nombre = direccion_uno
  end
end
