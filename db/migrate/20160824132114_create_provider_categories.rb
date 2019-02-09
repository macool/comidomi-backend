class CreateProviderCategories < ActiveRecord::Migration
  def change
    create_table :provider_categories do |t|
      t.string :titulo, null: false
      t.string :imagen
      t.text :descripcion

      t.timestamps null: false
    end

    add_index :provider_categories,
              :titulo,
              unique: true
  end
end
