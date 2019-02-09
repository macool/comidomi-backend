class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.string :lat
      t.string :lon
      t.string :nombre, null: false
      t.string :country, null: false

      t.timestamps null: false
    end
    add_index :places, [:nombre, :country], unique: true
    add_foreign_key :users, :places, column: :current_place_id
  end
end
