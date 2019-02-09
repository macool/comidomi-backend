require "rails_helper"

RSpec.describe Api::Customer::ServiceProvidersController,
               type: :request do
  describe "as a customer I see open providers first" do
    let(:user) { create :user, :customer }
    let(:provider_profile) {
      create :provider_profile,
             :with_provider_category,
             status: :active
    }
    let(:provider_office) {
      create :provider_office,
             :enabled,
             provider_profile: provider_profile
    }

    before do
      provider_profile
      provider_office
      login_as user
    end

    it {
      get_with_headers "/api/customer/service_providers"
      json = JSON.parse response.body
      provider = json["provider_profiles"].first
      office = provider["provider_offices"].first
      attrs = %w(
        provider_category_id
        nombre_establecimiento
        actividad_economica
      )
      attrs.each do |attribute|
        expect(provider[attribute]).to be_present
      end
      expect(office["weekdays"]).to be_a(Array)
    }
  end
end
