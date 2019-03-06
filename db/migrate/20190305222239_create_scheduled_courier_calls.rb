class CreateScheduledCourierCalls < ActiveRecord::Migration
  def change
    create_table :scheduled_courier_calls do |t|
      t.references :customer_order,
                   index: true,
                   foreign_key: true,
                   null: false
      t.text :couriers_called_ids, array: true, default: []
      t.boolean :done, default: false

      t.timestamps null: false
    end
  end
end
