require "rails_helper"

RSpec.describe Api::Customer::OrdersController,
               type: :request do
  before { login_as user }

  describe "as customer" do
    let(:user) { create :user, :customer }

    let(:previous_errand) {
      create :customer_errand,
             customer_profile: user.customer_profile
    }

    before do
      previous_errand
      get_with_headers "/api/customer/errands/#{previous_errand.id}"
    end

    it "answers with my previous order" do
      response_errand = JSON.parse(response.body).fetch("customer_errand")
      expect(
        response_errand["id"]
      ).to eq(previous_errand.id)
    end
  end
end
