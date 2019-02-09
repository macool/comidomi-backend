# == Schema Information
#
# Table name: provider_office_weekdays
#
#  id                 :integer          not null, primary key
#  provider_office_id :integer          not null
#  day                :string           not null
#  abierto            :boolean
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  hora_de_apertura   :datetime
#  hora_de_cierre     :datetime
#

FactoryGirl.define do
  factory :provider_office_weekday do
    provider_office

    day              "mon"
    # GMT-5 is ecuadorian time
    hora_de_cierre   "19:00 -0500"
    hora_de_apertura "10:00 -0500"
    abierto          true
  end
end
