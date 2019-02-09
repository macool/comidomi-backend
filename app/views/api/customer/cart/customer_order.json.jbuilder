json.customer_order do
  if @customer_order.present?
    json.partial!(
      "api/customer/customer_orders/customer_order",
      customer_order: @customer_order
    )
  else
    json.null!
  end
end
