class AddConfirmedAtToShippingRequest < ActiveRecord::Migration
  def change
    add_column :shipping_requests, :confirmed_at, :datetime
  end
end
