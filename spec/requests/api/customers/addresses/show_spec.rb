require "rails_helper"

RSpec.describe Api::Customer::AddressesController,
               type: :request do
  before { login_as user }

  let(:response_address) {
    JSON.parse(response.body).fetch("customer_address")
  }

  describe "customer" do
    let(:user) { create :user, :customer }

    let(:my_address) {
      create :customer_address,
             customer_profile: user.customer_profile
    }

    before do
      my_address
      get_with_headers "/api/customer/addresses/#{my_address.id}"
    end

    it "includes my address" do
      expect(
        response_address["id"]
      ).to eq(my_address.id)
    end
  end
end
