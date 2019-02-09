# == Schema Information
#
# Table name: site_preferences
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe SitePreference,
               type: :model do
  describe "factory" do
    subject { build :site_preference }
    it { is_expected.to be_valid }
  end
end
