require "rails_helper"

RSpec.describe Api::Provider::ItemsController,
               type: :request do
  describe "as provider" do
    let(:provider) { create :user, :provider }
    before { login_as provider }

    describe "updating an item" do
      let(:my_item) {
        create :provider_item,
               :with_provider_item_category,
               provider_profile: provider.provider_profile
      }

      before do
        my_item
        attributes = {
          provider_item_category_attributes: {
            nombre: "snacks"
          }
        }
        put_with_headers(
          "/api/provider/items/#{my_item.id}",
          attributes
        )
      end

      it "creates a personal category" do
        provider_item_category = ProviderItemCategory.last

        expect(
          provider_item_category.nombre
        ).to eq("snacks")

        expect(
          provider_item_category.personal
        ).to be_truthy

        expect(
          provider_item_category.provider_profile
        ).to eq(provider.provider_profile)
      end
    end

    describe "creating an item" do
      before do
        attributes = attributes_for(:provider_item).merge(
          provider_item_category_attributes: {
            nombre: "bebidas"
          }
        )
        post_with_headers(
          "/api/provider/items",
          attributes
        )
      end

      it "creates personal category" do
        provider_item_category = ProviderItemCategory.last

        expect(
          provider_item_category.nombre
        ).to eq("bebidas")

        expect(
          provider_item_category.personal
        ).to be_truthy

        expect(
          provider_item_category.provider_profile
        ).to eq(provider.provider_profile)
      end
    end
  end
end
