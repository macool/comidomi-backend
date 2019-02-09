require "rails_helper"

RSpec.describe Api::Provider::OfficesController,
               type: :request do
  describe "as provider" do
    let(:provider) { create :user, :provider }
    before { login_as provider }

    describe "lists my offices" do
      let(:my_office) {
        create :provider_office,
               provider_profile: provider.provider_profile
      }
      let(:other_provider_office) {
        create :provider_office
      }

      before {
        my_office
        other_provider_office
        get_with_headers "/api/provider/offices"
      }

      let(:response_offices) {
        JSON.parse(response.body).fetch("provider_offices")
      }

      it "response includes full office" do
        resp_office = response_offices.detect do |office|
          office["id"] == my_office.id
        end

        expect(resp_office).to be_present
        expect(resp_office).to have_key("enabled") # private attr

        resp_office_weekday = resp_office["weekdays"].first
        expect(resp_office_weekday).to have_key("hora_de_cierre")
      end

      it "response doesn't include other's office" do
        others_office = response_offices.detect do |office|
          office["id"] == other_provider_office.id
        end
        expect(others_office).to_not be_present
      end
    end
  end
end
