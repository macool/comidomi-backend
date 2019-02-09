class AddCantidadToItemProducto < ActiveRecord::Migration
  def change
    add_column :provider_items,
               :cantidad,
               :integer,
               default: 0
  end
end
