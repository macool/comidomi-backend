class MakeScheduledCourierCallResourcePolymorphic < ActiveRecord::Migration
  def up
    ScheduledCourierCall.destroy_all
    change_table :scheduled_courier_calls do |t|
      t.rename :customer_order_id, :resource_id
      t.string :resource_type, null: false
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
