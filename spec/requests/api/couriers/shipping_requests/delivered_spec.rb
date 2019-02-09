require "rails_helper"

RSpec.describe Api::Courier::ShippingRequestsController,
               type: :request do
  describe "I can deliver a shipping request" do
    let(:user) { create :user, :courier }

    let(:shipping_request) {
      create :shipping_request,
             :for_customer_order_delivery,
             :with_address_attributes
    }

    before do
      login_as user
      # assign to courier
      shipping_request.update!(
        status: :in_progress,
        courier_profile: user.courier_profile
      )
      post_with_headers "/api/courier/shipping_requests/#{shipping_request.id}/delivered"
    end

    it "includes shipping request" do
      response_request = JSON.parse(response.body).fetch("shipping_request")

      expect(
        response_request["status"]
      ).to eq("delivered")
    end
  end
end
