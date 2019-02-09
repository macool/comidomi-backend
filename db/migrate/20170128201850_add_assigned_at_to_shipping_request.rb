class AddAssignedAtToShippingRequest < ActiveRecord::Migration
  def change
    add_column :shipping_requests, :assigned_at, :datetime
  end
end
