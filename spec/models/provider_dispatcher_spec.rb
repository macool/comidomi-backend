# == Schema Information
#
# Table name: provider_dispatchers
#
#  id                 :integer          not null, primary key
#  provider_office_id :integer          not null
#  email              :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  deleted_at         :datetime
#

require 'rails_helper'

RSpec.describe ProviderDispatcher, type: :model do
  describe "factory" do
    subject { build :provider_dispatcher }
    it { is_expected.to be_valid }
  end
end
