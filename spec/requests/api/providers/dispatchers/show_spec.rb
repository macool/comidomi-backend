require "rails_helper"

RSpec.describe Api::Provider::OfficesController,
               type: :request do
  describe "as provider" do
    let(:provider) { create :user, :provider }
    before { login_as provider }

    describe "I can see my dispatchers" do
      let(:provider_office) {
        create :provider_office,
               provider_profile: provider.provider_profile
      }
      let(:provider_dispatcher) {
        create :provider_dispatcher,
               provider_office: provider_office
      }

      it {
        provider_dispatcher
        get_with_headers "/api/provider/dispatchers/#{provider_dispatcher.id}"

        json = JSON.parse(response.body)
        expect(
          json.fetch("provider_dispatcher").fetch("email")
        ).to eq(provider_dispatcher.email)
      }
    end
  end
end
