class CreateCustomerAddresses < ActiveRecord::Migration
  def change
    create_table :customer_addresses do |t|
      t.references :user,
                   null: false,
                   index: true,
                   foreign_key: true
      t.string :ciudad
      t.string :parroquia
      t.string :barrio
      t.string :direccion_uno
      t.string :direccion_dos
      t.string :codigo_postal
      t.text :referencia
      t.string :numero_convencional
      t.timestamps null: false
    end
  end
end
