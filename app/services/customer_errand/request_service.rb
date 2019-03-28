class CustomerErrand < ActiveRecord::Base
  class RequestService
    attr_reader :customer_errand

    delegate :valid?, :errors, to: :@customer_errand

    def initialize(user:, parameters:, resource_scope:)
      @user = user
      @parameters = parameters
      @resource_scope = resource_scope
      @customer_profile = user.customer_profile
      @customer_errand = build_customer_errand
    end

    def save
      valid? && submit_errand!
    end

    private

    def submit_errand!
      @customer_errand.transaction do
        create_shipping_request!
        @customer_errand.save!
      end
    end

    def create_shipping_request!
      ::ShippingRequest::GenerateService::CustomerErrandRequest.new(
        resource: @customer_errand
      ).perform!
    end

    def build_customer_errand
      @customer_errand = @resource_scope.new(
        place: @user.current_place,
        description: @parameters[:description],
        customer_address_id: customer_address_id,
        shipping_fare: shipping_fare
      )
    end

    def customer_address_id
      # filter inside customer profiles' addresses
      addresses = @user.customer_profile.customer_addresses
      addresses.find(@parameters[:customer_address_id]).id
    end

    ##
    # @note for now using cheapest fare
    # TODO?
    def shipping_fare
      ShippingFare.for_place(@user.current_place).smaller.first
    end
  end
end
