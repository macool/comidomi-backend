class CreateUserLocations < ActiveRecord::Migration
  def change
    create_table :user_locations do |t|
      t.string :lat, null: false
      t.string :lon, null: false
      t.references :user, null: false, index: true, foreign_key: true

      t.datetime :created_at, null: false
    end
  end
end
