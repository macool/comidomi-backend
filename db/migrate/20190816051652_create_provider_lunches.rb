class CreateProviderLunches < ActiveRecord::Migration
  def change
    create_table :provider_lunches do |t|
      t.references :provider_profile, index: true, null: false, foreign_key: true
      t.monetize :precio

      t.timestamps null: false
    end
  end
end
