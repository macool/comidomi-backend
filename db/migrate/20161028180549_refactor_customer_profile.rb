class RefactorCustomerProfile < ActiveRecord::Migration
  def change
    remove_column :customer_profiles, :fecha_de_nacimiento, :date
    remove_column :customer_profiles, :ciudad, :string

    add_column :users, :fecha_nacimiento, :date
    add_column :users, :ciudad, :string
  end
end
