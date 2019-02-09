require "rails_helper"

RSpec.describe Api::Courier,
               type: :request do
  describe "user with courier profile" do
    let(:user) { create :user, :courier }

    let(:response_courier_profile){
      JSON.parse(response.body)["data"]["courier_profile"]
    }

    it {
      login_as user

      expect(
        response_courier_profile["id"]
      ).to eq(user.courier_profile.id)
    }
  end
end
