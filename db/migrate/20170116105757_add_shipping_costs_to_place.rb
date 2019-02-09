class AddShippingCostsToPlace < ActiveRecord::Migration
  def change
    add_column :places, :price_per_km_cents, :integer, default: 1
    add_column :places, :factor_per_distance, :float, default: 0.1
  end
end
