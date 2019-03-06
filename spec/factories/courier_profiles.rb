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
#  receive_calls           :boolean          default(FALSE)
#  call_priority           :integer          default(0)
#

FactoryGirl.define do
  factory :courier_profile do
    user

    ruc              { Faker::Code.npi }
    email            { Faker::Internet.email }
    nombres          { Faker::Name.name }
    telefono         { Faker::PhoneNumber.phone_number }
    fecha_nacimiento { Faker::Date.birthday }
    place            {
      if user.present?
        user.current_place.presence
      else
        build(:place)
      end
    }
    tipo_licencia    {
      CourierProfile::TIPOS_LICENCIA.sample
    }
    tipo_medio_movilizacion {
      CourierProfile::TIPOS_MEDIO_MOVILIZACION.sample
    }
  end
end
