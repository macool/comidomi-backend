class RemoveForeignKeyForScheduledCalls < ActiveRecord::Migration
  def change
    remove_foreign_key "scheduled_courier_calls", column: "resource_id"
  end
end
