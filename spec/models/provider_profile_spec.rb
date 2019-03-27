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

require 'rails_helper'

RSpec.describe ProviderProfile,
               type: :model do
  describe "factory" do
    subject { build :provider_profile }
    it { is_expected.to be_valid }
  end

  describe "validates formas_de_pago" do
    subject { build :provider_profile }

    describe "valid" do
      before {
        subject.formas_de_pago = ProviderProfile::FORMAS_DE_PAGO.sample(2)
      }
      it { is_expected.to be_valid }
    end

    describe "invalid" do
      before {
        subject.formas_de_pago << "invalid"
      }
      it { is_expected.to_not be_valid }
    end

    describe "invalid" do
      before { subject.formas_de_pago = [] }
      it { is_expected.to_not be_valid }
    end
  end

  describe "generate_user" do
    subject {
      ProviderProfile.new(
        attributes_for(:provider_profile).merge(
          generate_user: "1"
        )
      )
    }
    it {
      expect {
        subject.save
      }.to change { User.count }.by(1)

      expect(
        User.last.email
      ).to eq(subject.email)
    }
  end
end
