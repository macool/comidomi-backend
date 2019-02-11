# == Schema Information
#
# Table name: courier_profiles
#
#  id                      :integer          not null, primary key
#  user_id                 :integer
#  nombres                 :string
#  ruc                     :string
#  telefono                :string
#  email                   :string
#  tipo_medio_movilizacion :string
#  fecha_nacimiento        :date
#  tipo_licencia           :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  place_id                :integer          not null
#

class CourierProfile < ActiveRecord::Base
  extend Enumerize

  TIPOS_LICENCIA = [
    "A",
    "A1",
    "B",
    "C1",
    "C",
    "D1",
    "D",
    "E1",
    "E",
    "F",
    "G"
  ].freeze

  TIPOS_MEDIO_MOVILIZACION = [
    "motocicleta-particular", # "Motocicleta particular", # (A)
    "motocicleta-comercial", # "Motocicleta comercial",   # (A1)
    "automovil-particular", # "Automóvil particular",     # (B)
    "automovil-estatal", # "Automóvil estatal",           # (C1)
    "automovil-comercial", # "Automóvil comercial",       # (C)
    "bus-escolar-turismo", # "Bus escolar / turismo",     # (D1)
    "bus-pasajeros", # "Bus pasajeros",                   # (D)
    "pesado", # "Pesado",                                 # (E)
    "especiales", # "Especiales"                          # (E1)
  ].freeze

  begin :relationships
    belongs_to :user
    belongs_to :place
  end

  begin :enumerables
    enumerize :tipo_licencia, in: TIPOS_LICENCIA
    enumerize :tipo_medio_movilizacion, in: TIPOS_MEDIO_MOVILIZACION
  end

  begin :validations
    validates :ruc,
              :nombres,
              :email,
              :telefono,
              :place_id,
              presence: true
    validates :ruc,
              :email,
              :telefono,
              uniqueness: true
  end

  begin :callbacks
    before_validation :set_email_from_user!, on: :create
  end

  private

  def set_email_from_user!
    return if user.nil?
    self.email = user.email
  end
end
