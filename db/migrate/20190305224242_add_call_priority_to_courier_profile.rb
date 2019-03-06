class AddCallPriorityToCourierProfile < ActiveRecord::Migration
  def change
    add_column :courier_profiles, :receive_calls, :boolean, default: false
    add_index :courier_profiles, :receive_calls
    add_column :courier_profiles, :call_priority, :integer, default: 0
  end
end
