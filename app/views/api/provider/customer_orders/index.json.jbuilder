json.customer_orders do
  json.array!(
    @api_collection,
    partial: "api/provider/customer_orders/customer_order",
    as: :customer_order
  )
end
