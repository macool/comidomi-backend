class CustomerErrand < ActiveRecord::Base
  class RequestService
    attr_reader :customer_errand

    delegate :valid?, to: :@customer_errand

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

    end

    def build_customer_errand
      @customer_errand = @resource_scope.new(
        place: @user.current_place,
        description: @parameters[:description]
      )
    end
  end
end
