require "rails_helper"

RSpec.describe Api::Provider::ItemsController,
               type: :request do
  let(:provider) { create :user, :provider }
  before { login_as provider }

  describe "create with image" do
    let(:placeholder_image) {
      uri = Rails.root.join("spec/fixtures/placeholder.png")
      Rack::Test::UploadedFile.new uri, "image/png"
    }

    let(:attributes) {
      attributes_for(
        :provider_item
      ).merge(imagenes_attributes: [
        { imagen: placeholder_image }
      ])
    }

    before do
      expect {
        post_with_headers(
          "/api/provider/items",
          attributes
        )
      }.to change { ProviderItemImage.count }.by(1)
    end

    it "response includes image" do
      json = JSON.parse(response.body)
      image = json["provider_item"]["imagenes"].first
      expect(image["id"]).to be_present
    end
  end

  describe "delete an image" do
    let(:provider_item) {
      create :provider_item,
             :with_imagen,
             provider_profile: provider.provider_profile
    }

    let(:attributes) {
      { imagenes_attributes: [
        {
          id: provider_item.imagenes.first.id,
          :_destroy => "1"
        }
      ]}
    }

    before do
      provider_item
      expect {
        put_with_headers(
          "/api/provider/items/#{provider_item.id}",
          attributes
        )
      }.to change { ProviderItemImage.count }.by(-1)
    end

    it "response doesn't have image" do
      json = JSON.parse(response.body)
      image = json["provider_item"]["imagenes"].first
      expect(image).to_not be_present
    end
  end
end
