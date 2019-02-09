require "rails_helper"

RSpec.describe Api::Users::DevicesController,
               type: :request do
  let(:user) { create :user }
  before { login_as user }

  it "updates device as mine" do
    existing_user_device = create(:user_device)

    post_with_headers(
      "/api/users/devices",
      uuid: existing_user_device.uuid,
      platform: :android
    )
    expect(response.status).to eq(201)
    json_response = JSON.parse(response.body)
    expect(
      json_response["user_device"]["id"]
    ).to_not eq(existing_user_device.id)
  end

  it "returns my current device" do
    existing_user_device = create(
      :user_device,
      user: user
    )

    post_with_headers(
      "/api/users/devices",
      uuid: existing_user_device.uuid,
      platform: existing_user_device.platform
    )

    json_response = JSON.parse(response.body)
    expect(
      json_response["user_device"]["id"]
    ).to_not eq(existing_user_device.id)
  end
end
