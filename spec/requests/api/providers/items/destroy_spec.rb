require "rails_helper"

RSpec.describe Api::Provider::ItemsController,
               type: :request do
  let(:provider) { create :user, :provider }
  before { login_as provider }

  let(:item) {
    create :provider_item,
           provider_profile: provider.provider_profile
  }

  describe "as provider" do
    before do
      item # make sure item is in DB
      post_with_headers(
        "/api/provider/items/#{item.id}",
        "_method" => "DELETE"
      )
    end

    it "performs a soft delete" do
      expect(item.reload.deleted_at).to be_present
    end

    it "response status and content" do
      expect(response.body).to be_empty
      expect(response.status).to eq(204)
    end
  end

  describe "can't delete a deleted item" do
    before do
      item.soft_destroy
    end

    it "raises exception" do
      expect {
        post_with_headers(
          "/api/provider/items/#{item.id}",
          "_method" => "DELETE"
        )
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
