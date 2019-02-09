class CustomerOrder
  class PusherNotifierService
    def self.notify!(customer_order)
      new(customer_order).notify!
    end

    def initialize(customer_order)
      @customer_order = customer_order
    end

    def notify!
      channel_name = "private-customer_order.#{@customer_order.id}"
      Pusher.trigger(channel_name, "update", pusher_json)
    end

    private

    def pusher_json
      view = ApplicationController.view_context_class.new(
        "#{Rails.root}/app/views/"
      )
      resource_json = JbuilderTemplate.new(view).encode do |json|
        json.partial! 'api/customer/customer_orders/customer_order', customer_order: @customer_order
      end
      { customer_order: resource_json }
    end
  end
end
