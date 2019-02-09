require "rails_helper"

RSpec.describe Api::Customer::OrdersController,
               type: :request do
  let(:response_order) {
    JSON.parse(response.body).fetch("customer_order")
  }

  describe "as provider" do
    let(:user) { create :user, :provider }

    let(:customer_order) {
      create :customer_order,
             :submitted,
             :with_order_item
    }
    let(:customer_order_item) {
      create :customer_order_item,
             customer_order: customer_order,
             provider_item: provider_item
    }
    let(:provider_item) {
      create :provider_item,
             provider_profile: user.provider_profile
    }

    before do
      login_as user
      customer_order
      customer_order_item
      customer_order.delivery_for_provider(user.provider_profile).update!(status: :pending)
      get_with_headers "/api/provider/customer_orders/#{customer_order.id}"
    end

    it "includes my pending order" do
      expect(
        response_order["id"]
      ).to eq(customer_order.id)

      expect(
        response_order["provider_profiles"].count
      ).to eq(1)
    end
  end
end
