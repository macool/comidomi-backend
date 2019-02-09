require "rails_helper"

RSpec.describe Api::Provider::OfficesController,
               type: :request do
  describe "as provider" do
    let(:provider) { create :user, :provider }
    before { login_as provider }

    describe "update my office" do
      let(:my_office) {
        create :provider_office,
               provider_profile: provider.provider_profile
      }

      let(:new_attributes) {
        attributes_for :provider_office
      }

      before {
        put_with_headers(
          "/api/provider/offices/#{my_office.id}",
          new_attributes
        )
      }

      let(:json) {
        JSON.parse response.body
      }

      it {
        expect(
          json["provider_office"]["direccion"]
        ).to eq(new_attributes[:direccion])
      }
    end

    describe "can't update other provider's office" do
      let(:other_office) { create :provider_office }

      it {
        expect {
          put_with_headers(
            "/api/provider/offices/#{other_office.id}"
          )
        }.to raise_error(ActiveRecord::RecordNotFound)
      }
    end
  end
end
