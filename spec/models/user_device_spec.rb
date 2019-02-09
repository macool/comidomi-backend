# == Schema Information
#
# Table name: user_devices
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  platform   :string           not null
#  uuid       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe UserDevice,
               type: :model do
  describe "factory" do
    subject { build :user_device }
    it { is_expected.to be_valid }
  end
end
