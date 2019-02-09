class AddPlaceToCourierProfile < ActiveRecord::Migration
  def change
    say_with_time "WARNING: wiping all courier profiles" do
      ShippingRequest.update_all(courier_profile_id: nil)
      CourierProfile.destroy_all
    end
    add_reference :courier_profiles, :place, index: true, foreign_key: true, null: false
    remove_column :courier_profiles, :ubicacion
  end
end
