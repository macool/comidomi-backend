require 'rails_helper'

RSpec.describe ProviderLunch, type: :model do
  describe "factory" do
    it { expect(build(:provider_lunch)).to be_valid }
  end
end
