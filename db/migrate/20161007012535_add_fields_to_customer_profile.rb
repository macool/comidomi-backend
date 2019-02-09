class AddFieldsToCustomerProfile < ActiveRecord::Migration
  def change
    add_column :customer_profiles, :fecha_de_nacimiento, :date
    add_column :customer_profiles, :ciudad, :string
  end
end
