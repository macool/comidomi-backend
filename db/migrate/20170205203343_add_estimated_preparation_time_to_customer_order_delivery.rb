class AddEstimatedPreparationTimeToCustomerOrderDelivery < ActiveRecord::Migration
  def change
    add_column :customer_order_deliveries, :preparation_time_mins, :integer
    add_column :customer_order_deliveries, :provider_responded_at, :datetime
  end
end
