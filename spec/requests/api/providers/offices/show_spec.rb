require "rails_helper"

RSpec.describe Api::Provider::OfficesController,
               type: :request do
  describe "as provider" do
    let(:provider) { create :user, :provider }
    before { login_as provider }

    describe "I can see my offices" do
      let(:provider_office) {
        create :provider_office,
               provider_profile: provider.provider_profile
      }

      it {
        provider_office
        get_with_headers "/api/provider/offices/#{provider_office.id}"

        json = JSON.parse(response.body)
        expect(
          json.fetch("provider_office").fetch("direccion")
        ).to eq(provider_office.direccion)
      }
    end
  end
end
