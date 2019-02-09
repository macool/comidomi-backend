require "rails_helper"

RSpec.describe Api::Provider::ItemCategoriesController,
               type: :request do
  describe "as provider" do
    let(:provider) { create :user, :provider }
    before { login_as provider }

    describe "index provider item categories" do
      let(:global_category) {
        create :provider_item_category,
               predeterminada: true
      }
      let(:personal_category) {
        create :provider_item_category,
               provider_profile: provider.provider_profile
      }
      let(:others_category) {
        create :provider_item_category,
               :personal
      }

      before {
        global_category
        personal_category
        others_category
        get_with_headers "/api/provider/item_categories"
      }

      let(:resp_categories) {
        JSON.parse(response.body).fetch("provider_item_categories")
      }

      it {
        expect(
          resp_categories.count
        ).to eq(2)

        expect(
          resp_categories.detect do |resp_category|
            resp_category["id"] == global_category.id
          end
        ).to be_present

        expect(
          resp_categories.detect do |resp_category|
            resp_category["id"] == personal_category.id
          end
        ).to be_present
      }
    end
  end
end
