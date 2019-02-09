class CreateProviderItems < ActiveRecord::Migration
  def change
    create_table :provider_items do |t|
      t.references :provider_profile,
                   index: true, foreign_key: true
      t.string :titulo, null: false
      t.text :descripcion
      t.integer :unidad_medida
      t.monetize :precio, null: false
      t.string :volumen
      t.string :peso
      t.string :imagen
      t.text :observaciones

      t.timestamps null: false
    end
  end
end
