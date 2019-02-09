class AddPlaceToCustomerOrder < ActiveRecord::Migration
  def change
    add_reference :customer_orders, :place, index: true, foreign_key: true
  end
end
