require "rails_helper"

RSpec.describe Api::Provider::DispatchersController,
               type: :request do
  describe "as non-provider" do
    let(:user) { create :user }
    before {
      login_as user
      get_with_headers "/api/provider/dispatchers"
    }
    it "says I'm not authorised" do
      expect(response.status).to eq(401)
    end
  end

  describe "as provider" do
    let(:current_place) { create :place, nombre: "loh" }
    let(:provider) {
      create :user,
             :provider,
             current_place: current_place
    }
    before { login_as provider }

    describe "lists my dispatchers" do
      let(:provider_office) {
        create :provider_office,
               provider_profile: provider.provider_profile
      }
      let(:provider_dispatcher) {
        create :provider_dispatcher,
               provider_office: provider_office
      }
      let(:other_provider_dispatcher) {
        create :provider_dispatcher
      }

      before {
        provider_dispatcher
        other_provider_dispatcher
        get_with_headers "/api/provider/dispatchers"
      }

      let(:json) {
        JSON.parse response.body
      }

      it "response includes my item" do
        my_dispatcher = json["provider_dispatchers"].detect do |dispatcher|
          dispatcher["id"] == provider_dispatcher.id
        end
        expect(my_dispatcher).to be_present
      end

      it "response doesn't include other's item" do
        another_dispatcher = json["provider_dispatchers"].detect do |dispatcher|
          dispatcher["id"] == other_provider_dispatcher.id
        end
        expect(another_dispatcher).to_not be_present
      end

      describe "response includes user" do
        let(:dispatcher_user) { create :user }
        let(:provider_dispatcher) {
          create :provider_dispatcher,
                 provider_office: provider_office,
                 email: dispatcher_user.email
        }

        it {
          dispatcher = json["provider_dispatchers"].detect do |dispatcher|
            dispatcher["id"] == provider_dispatcher.id
          end
          user = dispatcher["user"]
          expect(
            user["id"]
          ).to eq(dispatcher_user.id)
        }
      end
    end
  end
end
