require "rails_helper"

RSpec.describe Api::ProductsController,
               type: :request do
  let(:user) { create :user }
  before { login_as user }

  describe "lists products" do
    let!(:product) { create :provider_item, :en_stock, :available }
    before { get_with_headers "/api/products" }
    subject { JSON.parse response.body }

    it {
      expect(
        subject["products"].first["titulo"]
      ).to eq(product.titulo)
    }

    it "includes pagination" do
      expect(
        subject["meta"]["total_pages"]
      ).to be_present
    end
  end
end
