# == Schema Information
#
# Table name: scheduled_courier_calls
#
#  id                  :integer          not null, primary key
#  customer_order_id   :integer          not null
#  couriers_called_ids :text             default([]), is an Array
#  done                :boolean          default(FALSE)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

require 'rails_helper'

RSpec.describe ScheduledCourierCall, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
