class AddEtaToShippingRequest < ActiveRecord::Migration
  def change
    add_column :shipping_requests, :estimated_time_mins, :integer
  end
end
