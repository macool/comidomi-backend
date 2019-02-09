module Admin
  class ShippingCostsController < BaseController
    def show
      skip_policy_scope
      skip_authorization
      @place = get_place.decorate
    end

    def calculate
      skip_policy_scope
      skip_authorization
      @place = get_place
      assign_place_attributes(@place)
      @shipping_cost_calculator = get_shipping_cost_calculator
      @price_per_distance = @shipping_cost_calculator.send(:price_per_distance)
      render json: {
        distance: @price_per_distance.distance,
        shipping_fare: @shipping_cost_calculator.shipping_fare_price_cents / 100.0,
        price: @price_per_distance.total_price_cents_per_distance / 100.0,
        price_per_km: @price_per_distance.final_price_cents_per_km / 100.0,
        extra_price_per_km: @price_per_distance.extra_price_cents_per_km / 100.0,
      }
    end

    private

    def get_shipping_cost_calculator
      CustomerOrderDelivery::ShippingCostCalculatorService.new(
        place: @place,
        origin: @place,
        target: {
          lat: params[:lat],
          lon: params[:lon]
        }
      )
    end

    def assign_place_attributes(place)
      place.assign_attributes(
        params.require(:place).permit(
          :price_per_km_cents,
          :factor_per_distance
        )
      )
    end

    def get_place
      Admin::PlacePolicy::Scope.new(
        pundit_user,
        Place
      ).resolve.find(params[:place_id])
    end
  end
end
