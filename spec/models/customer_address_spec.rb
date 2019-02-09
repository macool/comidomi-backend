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

require 'rails_helper'

RSpec.describe CustomerAddress,
               type: :model do
  describe "factory" do
    subject { build :customer_address }
    it { is_expected.to be_valid }
  end

  describe "nombre gets set automatically" do
    subject { build :customer_address, nombre: nil }
    before { subject.save }
    it { expect(subject.nombre).to eq(subject.direccion_uno) }
    it {
      new_name = "something new"
      subject.update! nombre: new_name
      expect(subject.reload.nombre).to eq(new_name)
    }
  end
end
