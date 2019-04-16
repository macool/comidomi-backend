case customer_resource
when CustomerOrder
  json.partial! "api/customer/customer_orders/customer_order",
                customer_order: customer_resource
when CustomerErrand
  json.partial! "api/customer/customer_errands/customer_errand",
                customer_errand: customer_resource
  json.partial! "api/customer/customer_errands/shipping_request",
                customer_errand: customer_resource
end
