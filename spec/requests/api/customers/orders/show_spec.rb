require "rails_helper"

RSpec.describe Api::Customer::OrdersController,
               type: :request do
  before { login_as user }

  describe "as customer" do
    let(:user) { create :user, :customer }

    let(:previous_order) {
      create :customer_order,
             :submitted,
             customer_profile: user.customer_profile
    }

    before do
      previous_order
      get_with_headers "/api/customer/orders/#{previous_order.id}"
    end

    it "answers with my previous order" do
      response_order = JSON.parse(response.body).fetch("customer_order")
      expect(
        response_order["id"]
      ).to eq(previous_order.id)
    end
  end
end
