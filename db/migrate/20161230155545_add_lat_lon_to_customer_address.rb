class AddLatLonToCustomerAddress < ActiveRecord::Migration
  def change
    say_with_time "WARNING wiping all customer addresses" do
      CustomerOrderDelivery.destroy_all
      CustomerAddress.destroy_all
    end
    add_column :customer_addresses, :lat, :string, null: false
    add_column :customer_addresses, :lon, :string, null: false
  end
end
