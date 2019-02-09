require "rails_helper"

RSpec.describe Api::Provider::DispatchersController,
               type: :request do
  let(:provider) { create :user, :provider }
  let(:provider_office) {
    create :provider_office,
           provider_profile: provider.provider_profile
  }
  before {
    provider_office
    login_as provider
  }

  let(:attributes) {
    attributes_for(:provider_dispatcher).merge(
      provider_office_id: provider_office.id
    )
  }
  let(:dispatcher) {
    create :provider_dispatcher, attributes
  }

  describe "as provider" do
    before do
      dispatcher # make sure dispatcher is in DB
      post_with_headers(
        "/api/provider/dispatchers/#{dispatcher.id}",
        "_method" => "DELETE"
      )
    end

    it "performs a soft delete" do
      expect(dispatcher.reload.deleted_at).to be_present
    end

    it "response status and content" do
      expect(response.body).to be_empty
      expect(response.status).to eq(204)
    end
  end

  describe "can't delete a deleted dispatcher" do
    before do
      dispatcher.soft_destroy
    end

    it "raises exception" do
      expect {
        post_with_headers(
          "/api/provider/dispatchers/#{dispatcher.id}",
          "_method" => "DELETE"
        )
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
