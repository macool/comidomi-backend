class AddPlaceToShippingRequest < ActiveRecord::Migration
  def change
    add_reference :shipping_requests, :place, index: true, foreign_key: true
  end
end
