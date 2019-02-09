class CreateCustomerBillingAddresses < ActiveRecord::Migration
  def change
    create_table :customer_billing_addresses do |t|
      t.references :customer_profile,
                   index: true,
                   foreign_key: true,
                   null: false
      t.string :ciudad
      t.string :telefono
      t.string :email
      t.string :ruc, null: false
      t.string :razon_social, null: false
      t.string :direccion, null: false

      t.timestamps null: false
    end
  end
end
