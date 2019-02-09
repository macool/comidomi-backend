require "rails_helper"

RSpec.describe Api::ProvidersController,
               type: :request do
  let(:user) { create :user }
  before { login_as user }

  describe %q{
    showing a provider's public profile including their item categories
  } do
    let(:category) { create :provider_category }
    let(:provider_profile){
      create :provider_profile,
             :with_office,
             status: :active,
             provider_category: category
    }
    let(:provider_item) {
      create :provider_item,
             :en_stock,
             :available,
             provider_profile: provider_profile
    }

    before do
      provider_profile
      provider_item
    end

    let(:json) {
      JSON.parse response.body
    }

    describe "if I haven't set any categories" do
      let(:default_provider_item_category) {
        create :provider_item_category, :default
      }

      before do
        default_provider_item_category
        get_with_headers(
          "/api/categories/#{category.id}/providers/#{provider_profile.id}"
        )
      end

      it "all belongs to general category" do
        resp_provider = json.fetch("provider_profile")
        category = resp_provider.fetch("provider_item_categories").first
        item = category.fetch("provider_items").first

        expect(
          category["nombre"]
        ).to eq(default_provider_item_category.nombre)

        expect(
          item["id"]
        ).to eq(provider_item.id)
      end
    end

    describe "my own categories" do
      let(:provider_item_category) {
        create :provider_item_category,
               provider_profile: provider_profile
      }
      let(:provider_item) {
        create :provider_item,
               :en_stock,
               :available,
               provider_profile: provider_profile,
               provider_item_category: provider_item_category
      }

      before do
        get_with_headers(
          "/api/categories/#{category.id}/providers/#{provider_profile.id}"
        )
      end

      it {
        resp_provider = json.fetch("provider_profile")
        category = resp_provider.fetch("provider_item_categories").first
        item = category.fetch("provider_items").first

        expect(
          category["nombre"]
        ).to eq(provider_item_category.nombre)

        expect(
          item["id"]
        ).to eq(provider_item.id)
      }
    end
  end
end
