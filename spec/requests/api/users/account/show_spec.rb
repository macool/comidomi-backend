require "rails_helper"

RSpec.describe Api::Users::AccountsController,
               type: :request do
  before { login_as user }

  let(:response_user) {
    JSON.parse(response.body).fetch("user")
  }

  describe "without personal info" do
    let(:user) { create :user }

    before { get_with_headers "/api/users/account" }

    it {
      expect(response_user["email"]).to eq(user.email)
      expect(response_user["name"]).to eq(user.name)
    }
  end

  describe "with personal info" do
    let(:user) { create :user, :with_personal_info }

    before { get_with_headers "/api/users/account" }

    it "includes personal info" do
      expect(response_user["ciudad"]).to eq(user.ciudad)
      expect(
        response_user["fecha_nacimiento"]
      ).to eq(user.fecha_nacimiento.to_s)
    end

    it "should not include user password" do
      expect(response_user).to_not have_key("password")
    end
  end
end
