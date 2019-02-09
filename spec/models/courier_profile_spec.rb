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

require 'rails_helper'

RSpec.describe CourierProfile,
               type: :model do
  describe "factory" do
    subject { build :courier_profile }
    it { is_expected.to be_valid }
  end
end
