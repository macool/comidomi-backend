class CreateProviderDispatchers < ActiveRecord::Migration
  def change
    create_table :provider_dispatchers do |t|
      t.references :provider_office,
                   null: false,
                   index: true,
                   foreign_key: true
      t.string :email, null: false

      t.timestamps null: false
    end
  end
end
