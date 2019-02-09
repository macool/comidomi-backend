class AssignDefaultPlaceToShippingRequests < ActiveRecord::Migration
  def up
    if Place.count > 0 && ShippingRequest.count > 0
      say_with_time "making all shipping requests belong to first place" do
        place_id = Place.first.id
        ShippingRequest.find_each do |shipping_request|
          shipping_request.update!(place_id: place_id)
        end
      end
    end

    change_column :shipping_requests, :place_id, :integer, null: false
  end
end
