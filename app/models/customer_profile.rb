# == Schema Information
#
# Table name: customer_profiles
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class CustomerProfile < ActiveRecord::Base
  belongs_to :user
  has_many :customer_orders
  has_many :customer_errands
  has_many :customer_wishlists
  has_many :customer_addresses

  ##
  # returns an order in progress (if any)
  # @return CustomerOrder
  def current_order
    order_for_place(user.current_place)
  end

  def current_order_or_create_for(place)
    order_for_place(place).presence || customer_orders.create(
      place: place
    )
  end

  def order_for_place(place)
    customer_orders.with_status(:in_progress)
                   .for_place(place)
                   .first
  end
end
