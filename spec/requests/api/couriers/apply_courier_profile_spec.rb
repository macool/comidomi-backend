require "rails_helper"

RSpec.describe Api::Courier::ProfilesController,
               type: :request do
  let(:user) { create :user }
  before { login_as user }

  describe "doesn't create courier profile for user" do
    let(:invalid_attributes) {
      attributes_for(:courier_profile).except(:ruc)
    }

    before do
      post_with_headers(
        "/api/courier/profile",
        invalid_attributes
      )
    end

    it {
      expect(user.reload.courier_profile).to be_nil
    }

    it {
      json = JSON.parse response.body
      expect(
        json["errors"]["ruc"]
      ).to be_present
    }
  end

  describe "creates valid courier profile for user" do
    before do
      expect {
        post_with_headers(
          "/api/courier/profile",
          attributes_for(:courier_profile).merge(
            place_id: user.current_place.id
          )
        )
      }.to change{ CourierProfile.count }.by(1)
    end

    it {
      courier_profile = CourierProfile.last
      expect(courier_profile.user).to eq(user)
    }
  end

  describe "already courier" do
    let(:user) { create :user, :courier }

    before do
      expect {
        post_with_headers(
          "/api/courier/profile",
          attributes_for(:courier_profile)
        )
      }.to_not change(CourierProfile, :count)
    end

    it "gets halted by pundit" do
      expect(response.status).to eq(401)

      expect(
        JSON.parse(response.body)
      ).to have_key("error")
    end
  end
end
