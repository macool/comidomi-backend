require "rails_helper"

RSpec.describe Api::Courier::ShippingRequestsController,
               type: :request do
  describe "I can take pending shipping requests" do
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
        status: :assigned,
        courier_profile: user.courier_profile
      )
      post_with_headers "/api/courier/shipping_requests/#{shipping_request.id}/in_store"
    end

    it "includes shipping request" do
      response_request = JSON.parse(response.body).fetch("shipping_request")

      expect(
        response_request["status"]
      ).to eq("in_progress")
    end
  end
end
