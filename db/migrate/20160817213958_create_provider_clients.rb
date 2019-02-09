class CreateProviderClients < ActiveRecord::Migration
  def change
    create_table :provider_clients do |t|
      t.references :provider_profile, index: true, foreign_key: true
      t.text :notas
      t.string :ruc
      t.string :nombres
      t.string :direccion
      t.string :telefono
      t.string :email

      t.timestamps null: false
    end
  end
end
