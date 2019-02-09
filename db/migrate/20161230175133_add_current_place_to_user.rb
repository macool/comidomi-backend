class AddCurrentPlaceToUser < ActiveRecord::Migration
  def change
    add_reference :users,
                  :current_place,
                  index: true
  end
end
