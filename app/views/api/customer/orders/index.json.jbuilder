json.customer_orders do
  json.array!(
    @api_collection,
    partial: "api/customer/customer_orders/customer_order",
    as: :customer_order
  )
end
