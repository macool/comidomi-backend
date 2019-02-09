class CreateCourierProfiles < ActiveRecord::Migration
  def change
    create_table :courier_profiles do |t|
      t.references :user, index: true, foreign_key: true
      t.string :nombres
      t.string :ruc
      t.string :telefono
      t.string :email
      t.integer :ubicacion
      t.integer :tipo_medio_movilizacion
      t.date :fecha_nacimiento
      t.integer :tipo_licencia

      t.timestamps null: false
    end
  end
end
