class AddSubmittedAtToCustomerOrder < ActiveRecord::Migration
  def change
    add_column :customer_orders, :submitted_at, :datetime
    add_index :customer_orders, :submitted_at
  end
end
