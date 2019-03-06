require "rails_helper"

RSpec.describe Api::Customer::Cart::CheckoutsController,
               type: :request do
  include TimeZoneHelpers

  let(:place) { create :place, nombre: "loh" }
  let(:user) { create :user, :customer, current_place: place }
  before { login_as user }

  describe "submits my order" do
    let(:current_order) {
      create :customer_order,
             customer_profile: user.customer_profile
    }
    let(:order_item) {
      create :customer_order_item,
             customer_order: current_order
    }
    let(:provider_office) {
      create :provider_office,
             :enabled,
             provider_profile: order_item.provider_item.provider_profile
    }
    let(:shipping_fare) {
      create :shipping_fare,
             place: provider_office.place
    }
    let(:customer_address) {
      create :customer_address,
             customer_profile: user.customer_profile
    }
    let(:customer_billing_address) {
      create :customer_billing_address,
             customer_profile: user.customer_profile
    }
    let(:response_order) {
      JSON.parse(response.body).fetch("customer_order")
    }
    let(:submission_attributes) {
      {
        forma_de_pago: "efectivo",
        observaciones: "something",
        customer_billing_address_id: customer_billing_address.id,
        deliveries_attributes: [ {
          id: current_order.deliveries.first.id,
          provider_profile_id: order_item.provider_item.provider_profile.id,
          delivery_method: "shipping",
          customer_address_id: customer_address.id,
        } ]
      }
    }
    let(:courier_profile) {
      create :courier_profile, receive_calls: true
    }

    before do
      courier_profile
      current_order
      provider_office
      shipping_fare
      order_item
    end

    describe "invalid - without address" do
      let(:submission_attributes) {
        {
          forma_de_pago: "efectivo",
          customer_billing_address_id: customer_billing_address.id,
          deliveries_attributes: [ {
            id: current_order.deliveries.first.id,
            provider_profile_id: order_item.provider_item.provider_profile.id,
            delivery_method: "shipping",
          } ]
        }
      }

      before do
        post_with_headers(
          "/api/customer/cart/checkout",
          submission_attributes
        )
      end

      it {
        errors = JSON.parse(response.body).fetch("errors")
        expect(errors).to have_key("order_items")
      }
    end

    describe "successful submission" do
      before do
        post_with_headers(
          "/api/customer/cart/checkout",
          submission_attributes
        )
      end

      it "order is persisted" do
        expect(
          response_order["status"]
        ).to eq("submitted")
        expect(
          response_order["observaciones"]
        ).to eq(submission_attributes[:observaciones])
      end

      it "shipping fare gets cached" do
        delivery = current_order.deliveries.first.reload
        expect(
          delivery.read_attribute(:shipping_fare_price_cents)
        ).to be_present
      end
    end

    describe "successful - without address (pickup)" do
      let(:submission_attributes) {
        {
          forma_de_pago: "efectivo",
          customer_billing_address_id: customer_billing_address.id,
          deliveries_attributes: [ {
            id: current_order.deliveries.first.id,
            provider_profile_id: order_item.provider_item.provider_profile.id,
            delivery_method: "pickup"
          } ]
        }
      }

      before do
        post_with_headers(
          "/api/customer/cart/checkout",
          submission_attributes
        )
      end

      it {
        expect(
          response_order["status"]
        ).to eq("submitted")
        response_provider = response_order["provider_profiles"].first
        expect(
          response_provider["customer_order_delivery"]["delivery_method"]
        ).to eq("pickup")
      }
    end

    describe "deliver later" do
      let(:submission_attributes) {
        {
          forma_de_pago: "efectivo",
          observaciones: "something",
          customer_billing_address_id: customer_billing_address.id,
          deliveries_attributes: [ {
            id: current_order.deliveries.first.id,
            provider_profile_id: order_item.provider_item.provider_profile.id,
            delivery_method: "shipping",
            deliver_at: (Time.now + 2.hours).strftime("%Y-%m-%d %H:%M %z"),
            customer_address_id: customer_address.id
          } ]
        }
      }

      before do
        post_with_headers(
          "/api/customer/cart/checkout",
          submission_attributes
        )
      end

      it {
        response_provider = response_order["provider_profiles"].first
        expect(
          response_provider["customer_order_delivery"]["deliver_at"]
        ).to eq(
          formatted_time(
            submission_attributes[:deliveries_attributes].first[:deliver_at]
          )
        )
      }
    end

    describe "grouped by provider profile, can deliver to several addresses & pickup" do
      let(:future_shipping) {
        (Time.now + 2.hours).strftime("%Y-%m-%d %H:%M %z")
      }
      let(:submission_attributes) {
        {
          forma_de_pago: "efectivo",
          customer_billing_address_id: customer_billing_address.id,
          deliveries_attributes: [
            {
              id: current_order.delivery_for_provider(provider_one).id,
              provider_profile_id: provider_one.id,
              delivery_method: "shipping",
              customer_address_id: customer_address.id
            },
            {
              id: current_order.delivery_for_provider(provider_two).id,
              provider_profile_id: provider_two.id,
              delivery_method: "shipping",
              customer_address_id: second_customer_address.id,
              deliver_at: future_shipping
            },
            {
              id: current_order.delivery_for_provider(provider_three).id,
              provider_profile_id: provider_three.id,
              delivery_method: "pickup",
              deliver_at: (Time.now + 3.hours).strftime("%Y-%m-%d %H:%M %z")
            }
          ]
        }
      }
      let(:second_order_item) {
        create :customer_order_item,
               :ready_for_checkout,
               customer_order: current_order
      }
      let(:third_order_item) {
        create :customer_order_item,
               customer_order: current_order
      }
      let(:second_customer_address) {
        create :customer_address,
               customer_profile: user.customer_profile
      }
      let(:provider_one) {
        order_item.provider_item.provider_profile
      }
      let(:provider_two) {
        second_order_item.provider_item.provider_profile
      }
      let(:provider_three) {
        third_order_item.provider_item.provider_profile
      }

      before do
        second_order_item
        third_order_item
        second_customer_address
      end

      it "creates three customer order deliveries" do
        post_with_headers(
          "/api/customer/cart/checkout",
          submission_attributes
        )

        one = response_order["provider_profiles"].detect do |profile|
          profile["id"] == provider_one.id
        end
        expect(
          one["customer_order_delivery"]["customer_address_id"]
        ).to eq(customer_address.id)

        two = response_order["provider_profiles"].detect do |profile|
          profile["id"] == provider_two.id
        end
        expect(
          two["customer_order_delivery"]["deliver_at"]
        ).to eq(
          formatted_time(future_shipping)
        )

        three = response_order["provider_profiles"].detect do |profile|
          profile["id"] == provider_three.id
        end
        expect(
          three["customer_order_delivery"]["delivery_method"]
        ).to eq("pickup")
      end
    end

    describe "with both consumidor final & address" do
      let(:submission_attributes) {
        {
          forma_de_pago: "efectivo",
          anon_billing_address: true,
          customer_billing_address_id: customer_billing_address.id,
          deliveries_attributes: [ {
            id: current_order.deliveries.first.id,
            provider_profile_id: order_item.provider_item.provider_profile.id,
            delivery_method: "pickup"
          } ]
        }
      }

      before do
        post_with_headers(
          "/api/customer/cart/checkout",
          submission_attributes
        )
      end

      it {
        errors = JSON.parse(response.body).fetch("errors")
        expect(
          errors
        ).to have_key("anon_billing_address")
        expect(
          errors
        ).to have_key("customer_billing_address_id")
      }
    end

    describe "consumidor final" do
      let(:submission_attributes) {
        {
          forma_de_pago: "efectivo",
          anon_billing_address: true,
          deliveries_attributes: [ {
            id: current_order.deliveries.first.id,
            provider_profile_id: order_item.provider_item.provider_profile.id,
            delivery_method: "pickup"
          } ]
        }
      }

      before do
        post_with_headers(
          "/api/customer/cart/checkout",
          submission_attributes
        )
      end

      it {
        expect(
          response_order["status"]
        ).to eq("submitted")
        response_provider = response_order["provider_profiles"].first
        expect(
          response_order["anon_billing_address"]
        ).to eq(true)
      }
    end

    describe "checkout local items" do
      let(:non_local_place) {
        create(:place, nombre: "foreign")
      }
      let(:non_local_user) {
        create :user,
               current_place: non_local_place
      }
      let(:non_local_provider_profile) {
        create :provider_profile,
               :with_office,
               user: non_local_user
      }
      let(:non_local_provider_item) {
        create :provider_item,
               provider_profile: non_local_provider_profile
      }
      let(:non_local_order_item) {
        create :customer_order_item,
               customer_order: non_local_order,
               provider_item: non_local_provider_item
      }
      let(:non_local_order) {
        create :customer_order,
               customer_profile: user.customer_profile,
               place: non_local_place
      }
      let(:submission_attributes) {
        {
          forma_de_pago: "efectivo",
          anon_billing_address: true,
          deliveries_attributes: [ {
            id: current_order.deliveries.first.id,
            provider_profile_id: order_item.provider_item.provider_profile.id,
            delivery_method: "shipping",
            customer_address_id: customer_address.id
          } ]
        }
      }

      before do
        non_local_order_item
        post_with_headers(
          "/api/customer/cart/checkout",
          submission_attributes
        )
      end

      it {
        response_providers = response_order["provider_profiles"]

        expect(
          response_providers.find do |response_provider|
            response_provider["id"] == non_local_provider_profile.id
          end
        ).to_not be_present

        # but is in cart for other place
        user.update!(current_place: non_local_place)
        expect(
          user.customer_profile.current_order.provider_profiles
        ).to include(non_local_provider_profile)
      }
    end

    pending "notifies provider" do
      let(:provider_device) {
        create :user_device,
               platform: :android,
               user: order_item.provider_item.provider_profile.user
      }

      before do
        provider_device
        expect_any_instance_of(
          PushService::AndroidNotifier
        ).to receive(:notify!)
      end

      it {
        post_with_headers(
          "/api/customer/cart/checkout",
          submission_attributes
        )
      }
    end

    describe "notifies couriers" do
      before do
        expect_any_instance_of(
          PushService::AndroidNotifier
        ).to receive(:notify_topic!).and_call_original
      end

      it {
        post_with_headers(
          "/api/customer/cart/checkout",
          submission_attributes
        )
      }
    end

    describe "creates shipping request" do
      it "ATM deliveries will be automatically accepted and shipping requests automatically created" do
        expect {
          post_with_headers(
            "/api/customer/cart/checkout",
            submission_attributes
          )
        }.to change { ShippingRequest.count }.by(1)
      end
    end

    describe "discounts" do
      pending
    end
  end
end
