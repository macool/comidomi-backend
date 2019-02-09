require "rails_helper"

RSpec.describe Api::Provider::DispatchersController,
               type: :request do
  describe "as provider" do
    let(:provider) { create :user, :provider }
    let(:provider_office) {
      create :provider_office,
             provider_profile: provider.provider_profile
    }
    before {
      provider_office
      login_as provider
    }

    describe "update my dispatcher" do
      let(:attributes) {
        attributes_for(:provider_dispatcher).merge(
          provider_office_id: provider_office.id
        )
      }
      let(:my_dispatcher) {
        create :provider_dispatcher, attributes
      }
      let(:new_attributes) {
        attributes_for(:provider_dispatcher)
      }

      describe "successful operation" do
        before {
          put_with_headers(
            "/api/provider/dispatchers/#{my_dispatcher.id}",
            new_attributes
          )
        }

        let(:json) {
          JSON.parse response.body
        }

        it {
          expect(
            json["provider_dispatcher"]["email"]
          ).to eq(new_attributes[:email])
        }
      end

      describe "can't assign another provider's office to my dispatcher" do
        let(:other_office) { create :provider_office }

        before {
          put_with_headers(
            "/api/provider/dispatchers/#{my_dispatcher.id}",
            new_attributes.merge(provider_office_id: other_office.id)
          )
        }

        it {
          expect(response.status).to eq(401)
        }
      end
    end

    describe "can't update other provider's dispatcher" do
      let(:other_dispatcher) {
        create :provider_dispatcher
      }

      it "is out of my scope" do
        expect {
          put_with_headers(
            "/api/provider/dispatchers/#{other_dispatcher.id}"
          )
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
