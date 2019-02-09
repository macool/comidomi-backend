require 'rails_helper'

describe ProviderProfileDecorator,
         type: :decorator do
  describe "model" do
    subject { build_stubbed(:provider_profile).decorate }
    it { is_expected.to be_a(described_class) }
  end
end
