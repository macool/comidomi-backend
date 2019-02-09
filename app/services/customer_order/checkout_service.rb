class CustomerOrder < ActiveRecord::Base
  ##
  # to submit customer orders
  class CheckoutService
    delegate :errors, to: :validator

    def initialize(user, customer_order, submission_attributes)
      @user = user
      @customer_order = customer_order
      @submission_attributes = submission_attributes
    end

    ##
    # @return [Boolean]
    def save
      valid? && submit_order!
    end

    def valid?
      validator.valid?
    end

    private

    ##
    # @return [Boolean]
    def submit_order!
      submitter.submit_order! && notify_providers!
    end

    def submitter
      Submitter.new(@customer_order)
    end

    def validator
      @validator ||= Validator.new(
        @user,
        @customer_order,
        @submission_attributes
      )
    end

    def notify_providers!
      NotifyProviders.delay.run(@customer_order.id)
    end
  end
end
