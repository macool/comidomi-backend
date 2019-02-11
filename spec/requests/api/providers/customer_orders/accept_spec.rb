require "rails_helper"

RSpec.describe Api::Provider::CustomerOrdersController,
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
    let(:provider_office) {
      create :provider_office,
             :enabled,
             provider_profile: user.provider_profile
    }
    let(:customer_order_item) {
      create :customer_order_item,
             :ready_for_checkout,
             customer_order: customer_order,
             provider_item: provider_item
    }
    let(:provider_item) {
      create :provider_item,
             provider_profile: user.provider_profile
    }
    let(:customer_address) {
      create :customer_address,
             customer_profile: customer_order.customer_profile
    }
    let(:customer_billing_address) {
      create(:customer_billing_address,
             customer_profile: customer_order.customer_profile).tap do |customer_billing_address|
        customer_order.update! customer_billing_address: customer_billing_address
      end
    }

    before do
      provider_office
      login_as user
      customer_order
      customer_address
      customer_billing_address
      customer_order_item
      CustomerOrder::CheckoutService::Submitter.new(customer_order).submit_order!

      expect(Pusher).to receive(:trigger)

      post_with_headers(
        "/api/provider/customer_orders/#{customer_order.id}/accept",
        { preparation_time_mins: 29 }
      )
    end

    it "accepts my pending order" do
      expect(
        response_order["id"]
      ).to eq(customer_order.id)

      delivery = response_order["provider_profiles"].first["customer_order_delivery"]
      expect(
        delivery["status"]
      ).to eq("accepted")
      expect(
        delivery["preparation_time_mins"]
      ).to eq(29)
      expect(
        delivery["provider_responded_at"]
      ).to be_present

      shipping_request = ShippingRequest.last
      expect(
        shipping_request.kind
      ).to eq("customer_order_delivery")
      expect(
        shipping_request.resource.customer_order
      ).to eq(customer_order)
    end
  end
end
