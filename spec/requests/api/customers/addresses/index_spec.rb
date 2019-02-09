require "rails_helper"

RSpec.describe Api::Customer::AddressesController,
               type: :request do
  before { login_as user }

  let(:response_addresses) {
    JSON.parse(response.body).fetch("customer_addresses")
  }

  describe "non-customer" do
    let(:user) { create :user }

    before { get_with_headers "/api/customer/addresses" }

    it {
      expect(response_addresses).to be_empty
      expect(user.customer_profile).to_not be_present
    }
  end

  describe "customer" do
    let(:user) { create :user, :customer }

    let(:my_address) {
      create :customer_address,
             customer_profile: user.customer_profile
    }

    before do
      my_address

      get_with_headers "/api/customer/addresses"
    end

    it "includes my address" do
      expect(
        response_addresses.first["id"]
      ).to eq(my_address.id)
    end
  end
end
