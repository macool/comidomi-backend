require "rails_helper"

RSpec.describe Api::Users::AccountsController,
               type: :request do
  let(:user) { create :user }
  before { login_as user }

  let(:response_user) {
    JSON.parse(response.body).fetch("data")
  }

  describe "update my info" do
    let(:attributes) {
      attributes_for :user, :with_personal_info
    }

    before do
      put_with_headers(
        "/api/users/account",
        attributes
      )
    end

    it {
      expect(
        response_user["name"]
      ).to eq(attributes[:name])

      expect(
        response_user["ciudad"]
      ).to eq(attributes[:ciudad])
    }
  end
end
