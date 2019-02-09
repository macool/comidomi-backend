class AddRefCoordinatesToShippingRequest < ActiveRecord::Migration
  def change
    ShippingRequest.destroy_all
    add_column :shipping_requests, :ref_lat, :float, null: false
    add_column :shipping_requests, :ref_lon, :float, null: false
    add_index :shipping_requests, [:ref_lat, :ref_lon]
  end
end
