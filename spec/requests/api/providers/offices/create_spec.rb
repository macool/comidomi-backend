require "rails_helper"

RSpec.describe Api::Provider::OfficesController,
               type: :request do
  describe "non-provider" do
    let(:user) { create :user }
    before do
      login_as user
      post_with_headers(
        "/api/provider/offices",
        attributes_for(:provider_office)
      )
    end
    it { expect(response.status).to eq(401) }
  end

  describe "as provider" do
    let(:provider) { create :user, :provider }

    before { login_as provider }

    describe "can create offices" do
      let(:provider_office) {
        build :provider_office
      }
      let(:weekdays_attributes) {
        provider_office.weekdays.map do |weekday|
          weekday.attributes.slice(
            "day",
            "hora_de_cierre",
            "hora_de_apertura",
            "abierto"
          )
        end
      }
      let(:attributes) {
        # only required ones
        attributes_for(:provider_office).slice(
          :telefono,
          :direccion,
          :lat,
          :lon
        ).merge(
          place_id: provider.current_place.id,
          weekdays_attributes: weekdays_attributes
        )
      }

      before do
        expect {
          post_with_headers(
            "/api/provider/offices",
            attributes
          )
        }.to change { ProviderOffice.count }.by(1)
      end

      it "gets assigned to the right provider" do
        office = ProviderOffice.last
        expect(
          office.provider_profile
        ).to eq(provider.provider_profile)
      end

      it "response" do
        response_provider_office = JSON.parse(response.body).fetch("provider_office")

        expect(
          response_provider_office["direccion"]
        ).to eq(attributes[:direccion])

        provider_office_weekday = response_provider_office["weekdays"].first
        expect(
          provider_office_weekday["hora_de_apertura"]
        ).to eq(
          I18n.l(
            weekdays_attributes.first["hora_de_apertura"].in_time_zone(
              Rails.application.config.time_zone
            ),
            format: :office_schedule
          )
        )
      end
    end
  end
end
