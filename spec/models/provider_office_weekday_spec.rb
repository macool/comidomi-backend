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

require 'rails_helper'

RSpec.describe ProviderOfficeWeekday,
               type: :model do
  describe "factory" do
    subject { build :provider_office_weekday }
    it { is_expected.to be_valid }
  end

  describe "allows setting schedule with timezone" do
    let(:provider_office_weekday) {
      create :provider_office_weekday,
              hora_de_cierre: '23:00 -0500'
    }
    it {
      expect(
        provider_office_weekday.hora_de_cierre
      ).to be_a(Time)

      expect(
        provider_office_weekday.hora_de_cierre.strftime("%H:%M %z")
      ).to eq("23:00 -0500")
    }
  end

  describe "validates labor days" do
    subject { build :provider_office_weekday }
    describe "valid" do
      before {
        subject.day = "tue"
      }
      it {
        is_expected.to be_valid
        expect(subject.day).to be_tue
      }
    end

    describe "invalid" do
      before {
        subject.day = 'Enero'
      }
      it { is_expected.to_not be_valid }
    end
  end
end
