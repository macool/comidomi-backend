require "rails_helper"

RSpec.describe Api::Customer::OrdersController,
               type: :request do
  before { login_as user }

  let(:response_resources) {
    JSON.parse(response.body).fetch("customer_resources")
  }

  describe "customer" do
    let(:user) { create :user, :customer }

    let(:previous_errand) {
      create :customer_errand,
             customer_profile: user.customer_profile
    }

    before do
      previous_errand

      get_with_headers "/api/customer/orders"
    end

    it "includes my previous errand" do
      response_resource = response_resources.first
      expect(response_resource["id"]).to eq(previous_errand.id)
      expect(response_resource["kind"]).to eq("customer_errand")
      expect(response_resource["customer_profile"]).to be_present
    end
  end
end
