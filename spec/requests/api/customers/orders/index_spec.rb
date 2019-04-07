require "rails_helper"

RSpec.describe Api::Customer::OrdersController,
               type: :request do
  before { login_as user }

  let(:response_orders) {
    JSON.parse(response.body).fetch("customer_resources")
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
             :with_order_item,
             customer_profile: user.customer_profile
    }

    let(:previous_delivery) { previous_order.deliveries.first }

    let(:previous_shipping) {
      create :shipping_request,
             :for_customer_order_delivery,
             :assigned_to_courier,
             :with_address_attributes,
             resource: previous_delivery
    }

    let(:default_shipping_fare) {
      create :shipping_fare, place: previous_order.place
    }

    let(:current_order) {
      create :customer_order,
             status: :in_progress,
             customer_profile: user.customer_profile
    }

    before do
      previous_order
      default_shipping_fare
      previous_delivery
      previous_shipping
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

    it "includes shipping requests summary" do
      resp_order = response_orders.first
      resp_provider_profile = resp_order["provider_profiles"].first
      resp_shipping_request = resp_provider_profile["customer_order_delivery"]["shipping_request"]
      expect(resp_shipping_request["status"]).to eq("assigned")
      expect(resp_shipping_request["courier_profile"]["nombres"]).to be_present
    end
  end
end
