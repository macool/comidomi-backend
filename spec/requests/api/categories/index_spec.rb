require "rails_helper"

RSpec.describe Api::CategoriesController,
               type: :request do
  let(:user) { create :user }
  before { login_as user }

  let(:json) { JSON.parse response.body }

  describe "lists categories and providers" do
    before do
      provider_category
      provider_profile
      invisible_profile
      get_with_headers "/api/categories"
    end

    let(:provider_category) {
      create :provider_category,
             titulo: "Alimentos preparados"
    }
    let(:provider_profile) {
      create :provider_profile,
             :with_office,
             status: :active,
             provider_category: provider_category
    }
    let(:invisible_profile) {
      create :provider_profile,
             provider_category: provider_category
    }

    it "should include category" do
      expect(
        response.body
      ).to include("Alimentos preparados")
    end

    it "includes provider inside category" do
      expect(
        response.body
      ).to include(provider_profile.nombre_establecimiento)
    end

    it "excludes non-active provider profiles" do
      expect(
        response.body
      ).to_not include(invisible_profile.nombre_establecimiento)
    end

    describe "response" do
      let(:response_category) { json["provider_categories"].first }

      it "doesn't include full provider info" do
        expect(
          response_category["provider_profiles"].first
        ).to_not have_key("offices")
      end

      it "full imagen url is rendered" do
        expect(
          response_category["imagen_url"]
        ).to include(Rails.application.secrets.host)
      end
    end
  end

  describe "disabled category" do
    before do
      disabled_category
      get_with_headers "/api/categories"
    end

    let(:disabled_category) {
      create :provider_category,
             status: :disabled
    }

    it "should not be included" do
      expect(
        json["provider_categories"].detect do |resp_category|
          resp_category["id"] == disabled_category.id
        end
      ).to_not be_present
    end
  end
end
