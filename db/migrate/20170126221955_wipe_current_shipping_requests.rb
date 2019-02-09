class WipeCurrentShippingRequests < ActiveRecord::Migration
  def up
    say_with_time "WARNING: wiping all shipping requests" do
      ShippingRequest.destroy_all
    end
  end

  def down
    say "nothing to do about these"
  end
end
