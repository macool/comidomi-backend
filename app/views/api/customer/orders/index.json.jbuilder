json.customer_resources do
  json.array! @api_collection do |resource|
    case resource
    when CustomerOrder
      json.partial! "api/customer/customer_orders/customer_order",
                    customer_order: resource
    when CustomerErrand
      json.partial! "api/customer/customer_errands/customer_errand",
                    customer_errand: resource
      json.partial! "api/customer/customer_errands/shipping_request",
                    customer_errand: resource
    end
  end
end
