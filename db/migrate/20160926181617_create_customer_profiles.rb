class CreateCustomerProfiles < ActiveRecord::Migration
  def change
    create_table :customer_profiles do |t|
      t.references :user,
                   null: false,
                   index: true,
                   foreign_key: true

      t.timestamps null: false
    end
  end
end
