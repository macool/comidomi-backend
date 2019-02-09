require "rails_helper"

RSpec.describe Api::Courier::ShippingRequestsController,
               type: :request do
  describe "I can see pending shipping requests" do
    let(:user) { create :user, :courier }

    let(:shipping_request) {
      create :shipping_request,
             :with_address_attributes,
             kind: :ask_to_validate
    }

    let(:others_shipping_request) {
      create :shipping_request,
             :with_address_attributes,
             kind: :ask_to_validate,
             status: :delivered
    }

    before do
      login_as user
      shipping_request
      others_shipping_request
      get_with_headers "/api/courier/shipping_requests?status=new"
    end

    it "includes shipping request" do
      response_request = JSON.parse(response.body).fetch("shipping_requests").first

      expect(
        response_request["provider_profile"]["nombre_establecimiento"]
      ).to eq(
        shipping_request.resource.nombre_establecimiento
      )

      expect(
        response_request["address_attributes"]["direccion"]
      ).to be_present
    end

    it "doesnt include another's shipping request" do
      response_requests = JSON.parse(response.body).fetch("shipping_requests")
      expect(
        response_requests.detect do |req|
          req["id"] == others_shipping_request.id
        end
      ).to_not be_present
    end
  end
end
