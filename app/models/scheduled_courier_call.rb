# == Schema Information
#
# Table name: scheduled_courier_calls
#
#  id                  :integer          not null, primary key
#  resource_id         :integer          not null
#  couriers_called_ids :text             default([]), is an Array
#  done                :boolean          default(FALSE)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  resource_type       :string           not null
#

class ScheduledCourierCall < ActiveRecord::Base
  belongs_to :resource, polymorphic: true

  validates :resource, presence: true

  def shipping_request_resources
    case resource_type
    when "CustomerOrder"
      resource.deliveries
    else
      resource
    end
  end
end
