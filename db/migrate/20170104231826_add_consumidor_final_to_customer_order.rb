class AddConsumidorFinalToCustomerOrder < ActiveRecord::Migration
  def change
    add_column :customer_orders, :anon_billing_address, :boolean, default: false
  end
end
