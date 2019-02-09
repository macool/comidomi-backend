class CustomerOrderDelivery < ActiveRecord::Base
  class ShippingCostCalculatorService
    class PricePerDistanceCalculator
      delegate :place, :origin, :target, to: :@cost_calculator

      def initialize(cost_calculator)
        @cost_calculator = cost_calculator
      end

      def total_price_cents_per_distance
        final_price_cents_per_km * distance
      end

      def extra_price_cents_per_km
        (place.factor_per_distance * place.price_per_km_cents) * (distance_to_place_center)
      end

      def final_price_cents_per_km
        extra_price_cents_per_km + place.price_per_km_cents
      end

      def distance
        @distance ||= origin_location.distance_to(target_location_str)
      end

      def distance_to_place_center
        place_center_location.distance_to(target_location_str)
      end

      private

      def place_center_location
        Geokit::LatLng.new(
          place[:lat],
          place[:lon]
        )
      end

      def origin_location
        Geokit::LatLng.new(
          origin[:lat],
          origin[:lon]
        )
      end

      def target_location_str
        "#{target[:lat]},#{target[:lon]}"
      end
    end
  end
end
