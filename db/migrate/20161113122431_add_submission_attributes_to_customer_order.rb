class AddSubmissionAttributesToCustomerOrder < ActiveRecord::Migration
  def change
    add_column :customer_orders,
               :deliver_at,
               :datetime
    add_column :customer_orders,
               :delivery_method,
               :integer
    add_column :customer_orders,
               :forma_de_pago,
               :integer
    add_column :customer_orders,
               :observaciones,
               :text
    add_column :customer_orders,
               :customer_address_attributes,
               :text
    add_column :customer_orders,
               :customer_billing_address_attributes,
               :text
    add_reference :customer_orders,
                  :customer_address,
                  index: true,
                  foreign_key: true
    add_reference :customer_orders,
                  :customer_billing_address,
                  index: true,
                  foreign_key: true
  end
end
