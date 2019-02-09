# == Schema Information
#
# Table name: user_locations
#
#  id         :integer          not null, primary key
#  lat        :string           not null
#  lon        :string           not null
#  user_id    :integer          not null
#  created_at :datetime         not null
#

require 'rails_helper'

RSpec.describe UserLocation,
               type: :model do
  describe "factory" do
    subject { build :user_location }
    it { is_expected.to be_valid }
  end
end
