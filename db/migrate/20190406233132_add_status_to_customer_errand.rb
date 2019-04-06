class AddStatusToCustomerErrand < ActiveRecord::Migration
  def change
    add_column :customer_errands, :status, :string, null: false, default: "in_progress"
  end
end
