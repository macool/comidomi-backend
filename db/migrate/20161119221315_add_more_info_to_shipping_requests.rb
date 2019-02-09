class AddMoreInfoToShippingRequests < ActiveRecord::Migration
  def change
    add_column :shipping_requests,
               :status,
               :string,
               null: false,
               default: ShippingRequest::STATUSES.first

    add_column :shipping_requests,
               :address_attributes,
               :json

    add_index :shipping_requests, :status

    add_reference :shipping_requests,
                  :courier_profile,
                  index: true,
                  foreign_key: true
  end
end
