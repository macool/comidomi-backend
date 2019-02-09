require "rails_helper"

RSpec.describe Api::Customer::BillingAddressesController,
               type: :request do
  before { login_as user }

  let(:response_billing_address) {
    JSON.parse(response.body).fetch("customer_billing_address")
  }

  describe "as customer" do
    let(:user) { create :user, :customer }

    let(:my_billing_address) {
      create :customer_billing_address,
             customer_profile: user.customer_profile
    }

    before do
      my_billing_address
      get_with_headers(
        "/api/customer/billing_addresses/#{my_billing_address.id}"
      )
    end

    it "includes my address" do
      expect(
        response_billing_address["id"]
      ).to eq(my_billing_address.id)
    end
  end
end
