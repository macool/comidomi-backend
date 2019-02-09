json.extract!(
  customer_order,
  :id,
  :status,
  :observaciones,
  :forma_de_pago,
  :anon_billing_address,
  :subtotal_items_cents,
  :subtotal_items_currency,
  :customer_billing_address_id
)

json.submitted_at(
  l(customer_order.submitted_at, format: :api)
) if customer_order.submitted_at.present?

if customer_order.status.submitted?
  json.customer_profile do
    json.partial!(
      "api/customer/customer_orders/customer_profile",
      customer_profile: customer_order.customer_profile
    )
  end

  if customer_order.customer_billing_address.present?
    json.customer_billing_address do
      json.partial!(
        "api/customer/billing_addresses/billing_address",
        billing_address: customer_order.customer_billing_address
      )
    end
  end
end
