require "rails_helper"

RSpec.describe Api::Users::DevicesController,
               type: :request do
  let(:user) { create :user }
  before { login_as user }

  it "unregisters my device" do
    existing_user_device = create :user_device,
                                  user: user,
                                  platform: :android

    expect {
      post_with_headers(
        "/api/users/devices/unregister",
        uuid: existing_user_device.uuid,
        platform: :android
      )
    }.to change{ user.user_devices.count }.by(-1)
    expect(response.status).to eq(200)
  end
end
