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

require 'rails_helper'

RSpec.describe CustomerErrand, type: :model do
  it {
    errand = build(:customer_errand)
    expect(errand).to be_valid
  }
end
