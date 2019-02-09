require "rails_helper"

RSpec.describe Api::Users::AccountsController,
               type: :request do
  let(:user) { create :user }
  before { login_as user }

  it "agree TOS" do
    post_with_headers "/api/users/tos"
    expect(response.status).to eq(202)
    expect(user.reload).to be_agreed_tos
  end
end
