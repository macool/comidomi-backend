# == Schema Information
#
# Table name: customer_errands
#
#  id                  :integer          not null, primary key
#  customer_profile_id :integer          not null
#  place_id            :integer          not null
#  description         :text             not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class CustomerErrand < ActiveRecord::Base
  belongs_to :customer_profile
  belongs_to :place

  validates :customer_profile,
            :place,
            :description,
            presence: true
end
