require "rails_helper"

RSpec.describe Api::TosController,
               type: :request do
  describe "tos" do
    it {
      create :site_preference,
             name: "tos",
             content: "condiciones"
      get "/api/tos"
      expect(
        JSON.parse(response.body).fetch("tos")
      ).to include("condiciones")
    }
  end
end
