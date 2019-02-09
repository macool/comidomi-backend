require "rails_helper"

RSpec.describe Api::ProvidersController,
               type: :request do
  let(:user) { create :user }
  before { login_as user }

  describe "list of providers which belong to a category" do
    let(:category) { create :provider_category }
    let(:provider_profile){
      create :provider_profile,
             status: :active,
             provider_category: category
    }
    let(:provider_office) {
      # visible in api
      create :provider_office,
             :enabled,
             provider_profile: provider_profile
    }
    let(:disabled_provider_office) {
      # not visible as it's not enabled
      # by default
      create :provider_office,
             provider_profile: provider_profile
    }

    before do
      category
      provider_profile
      provider_office
      get_with_headers "/api/categories/#{category.id}/providers"
    end

    let(:json) {
      JSON.parse response.body
    }

    let(:provider_from_response) {
      providers = json["provider_category"]["provider_profiles"]
      provider = providers.detect do |provider|
        provider["id"] == provider_profile.id
      end
    }

    let(:office_from_response) {
      provider_from_response["provider_offices"].first
    }

    it "should include provider profile" do
      expect(provider_from_response).to be_present
    end

    it "includes complete info for provider profile" do
      expect(
        office_from_response["weekdays"].first
      ).to have_key("hora_de_apertura")
    end

    it "doesn't include private office attributes" do
      expect(
        office_from_response
      ).to_not have_key("enabled")
    end

    it "doesn't include disabled offices" do
      disabled_office = json["provider_category"]["provider_profiles"].detect do |provider|
        provider["id"] == disabled_provider_office.id
      end
      expect(disabled_office).to_not be_present
    end
  end
end
