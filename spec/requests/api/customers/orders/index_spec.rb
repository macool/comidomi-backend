require "rails_helper"

RSpec.describe Api::Customer::OrdersController,
               type: :request do
  before { login_as user }

  let(:response_orders) {
    JSON.parse(response.body).fetch("customer_orders")
  }

  describe "non-customer" do
    let(:user) { create :user }

    before { get_with_headers "/api/customer/orders" }

    it {
      expect(response_orders).to be_empty
      expect(user.customer_profile).to_not be_present
    }
  end

  describe "customer" do
    let(:user) { create :user, :customer }

    let(:previous_order) {
      create :customer_order,
             :submitted,
             customer_profile: user.customer_profile
    }
    
    let(:current_order) {
      create :customer_order,
             status: :in_progress,
             customer_profile: user.customer_profile
    }

    before do
      previous_order
      current_order

      get_with_headers "/api/customer/orders"
    end

    it "includes my previous order" do
      expect(
        response_orders.first["id"]
      ).to eq(previous_order.id)
    end
    
    it "doesn't include current order" do
      expect(
        response_orders.length
      ).to eq(1)
    end
  end
end
