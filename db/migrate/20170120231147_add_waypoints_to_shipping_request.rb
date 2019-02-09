class AddWaypointsToShippingRequest < ActiveRecord::Migration
  def change
    add_column :shipping_requests, :waypoints, :json
  end
end
