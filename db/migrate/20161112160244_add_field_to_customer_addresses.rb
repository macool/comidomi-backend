class AddFieldToCustomerAddresses < ActiveRecord::Migration
  def change
    add_column :customer_addresses, :nombre, :string
  end
end
