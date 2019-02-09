class CreateProviderOffices < ActiveRecord::Migration
  def change
    create_table :provider_offices do |t|
      t.references :provider_profile,
                   null: false,
                   index: true,
                   foreign_key: true
      t.boolean :enabled, default: false
      t.string :direccion, null: false
      t.string :ciudad
      t.string :horario

      t.timestamps null: false
    end
    add_index :provider_offices, :enabled
  end
end
