class AddReasonToShippingRequest < ActiveRecord::Migration
  def change
    add_column :shipping_requests, :reason, :string
  end
end
