require "rails_helper"

RSpec.describe Api::Customer::Cart::ItemsController,
               type: :request do
  let(:user) {
    create :user, :customer, current_place: place
  }
  let(:customer_order) {
    create :customer_order,
           customer_profile: user.customer_profile
  }
  let(:order_item_1) {
    create :customer_order_item,
           customer_order: customer_order,
           provider_item: provider_item
  }
  let(:customer_address) {
    create :customer_address,
           customer_profile: user.customer_profile,
           lat: "-4.005712610571117",
           lon: "-79.20174904167652"
  }
  let(:provider_item) {
    create :provider_item,
           provider_profile: provider
  }
  let(:provider) {
    provider_office.provider_profile
  }
  let(:provider_office) {
    create :provider_office,
           :enabled,
           lat: "-4.014831197482724",
           lon: "-79.20104093849659",
           place: place
  }
  let(:place) {
    create :place,
           lat: "-3.996807976918554",
           lon: "-79.201834872365",
           price_per_km_cents: 100,
           factor_per_distance: 0.1
  }
  let(:shipping_fares) {
    %w(100 150 250).map do |price_cents|
      create :shipping_fare,
             price_cents: price_cents,
             place: place
    end
  }

  before do
    login_as user

    shipping_fares
    customer_address
    order_item_1

    get_with_headers "/api/customer/cart"
  end

  it {
    resp_order = JSON.parse(response.body).fetch "customer_order"
    resp_provider = resp_order["provider_profiles"].first
    resp_delivery = resp_provider["customer_order_delivery"]

    expect(
      resp_delivery["shipping_fare_price_cents"]
    ).to eq(shipping_fares[1].price_cents)
  }

  it "distance, price & extra price get calculated" do
    # TODO
    # OFC would be nice to have this in a unit test
    customer_order_delivery = order_item_1.customer_order.deliveries.first
    cost_calculator = customer_order_delivery.send :shipping_cost_calculator
    price_per_distance = cost_calculator.send :price_per_distance

    # we'll try to match 1km to make things easier
    expect(
      price_per_distance.distance.round
    ).to eq(1)
    expect(
      price_per_distance.distance_to_place_center.round
    ).to eq(1)
    expect(
      price_per_distance.extra_price_cents_per_km.round
    ).to eq(10)
    expect(
      price_per_distance.final_price_cents_per_km.round
    ).to eq(110)
    expect(
      price_per_distance.total_price_cents_per_distance.round
    ).to eq(112) # lat/lon in the spec is not 100% precise
  end
end
