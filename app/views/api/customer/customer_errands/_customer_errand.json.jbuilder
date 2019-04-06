json.partial! "api/customer/errands/customer_errand",
              customer_errand: customer_errand

json.customer_profile do
  json.partial!(
    "api/customer/customer_orders/customer_profile",
    customer_profile: customer_errand.customer_profile
  )
end
