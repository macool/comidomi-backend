class CreateProviderProfiles < ActiveRecord::Migration
  def change
    create_table :provider_profiles do |t|
      t.references :user, index: true, foreign_key: true
      t.string :ruc
      t.string :razon_social
      t.string :actividad_economica
      t.string :tipo_contribuyente
      t.string :representante_legal
      t.string :telefono
      t.string :email
      t.date :fecha_inicio_actividad
      t.string :banco_nombre
      t.string :banco_numero_cuenta
      t.string :banco_identificacion
      t.string :website
      t.string :facebook_handle
      t.string :twitter_handle
      t.string :instagram_handle
      t.string :youtube_handle
      t.text :mejor_articulo
      t.text :formas_de_pago, array: true, default: []

      t.timestamps null: false
    end
  end
end
