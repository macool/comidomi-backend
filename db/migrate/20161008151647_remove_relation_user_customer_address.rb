class RemoveRelationUserCustomerAddress < ActiveRecord::Migration
  def change
    remove_column :customer_addresses, :user_id, :integer
    add_reference :customer_addresses,
                  :customer_profile,
                  null: false,
                  index: true,
                  foreign_key: true
  end
end
