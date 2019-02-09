class CreateProviderOfficeWeekdays < ActiveRecord::Migration
  def change
    create_table :provider_office_weekdays do |t|
      t.references :provider_office, index: true, foreign_key: true, null: false
      t.string :day, null: false
      t.time :hora_de_apertura
      t.time :hora_de_cierre
      t.boolean :abierto

      t.timestamps null: false
    end
  end
end
