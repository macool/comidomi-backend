class CreateCustomerErrands < ActiveRecord::Migration
  def change
    create_table :customer_errands do |t|
      t.references :customer_profile, index: true, foreign_key: true, null: false
      t.references :place, index: true, foreign_key: true, null: false
      t.text :description, null: false

      t.timestamps null: false
    end
  end
end
