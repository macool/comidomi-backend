require "rails_helper"

RSpec.describe Api::Users::PlacesController,
               type: :request do
  let(:user) { create :user }
  before { login_as user }

  it "I see available places" do
    place = create :place, :enabled
    get_with_headers "/api/users/places"
    places = JSON.parse(response.body).fetch("places")
    response_place = places.detect { |p| p["id"] == place.id }
    expect(response_place["nombre"]).to eq(place.nombre)
  end
end
