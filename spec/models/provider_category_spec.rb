# == Schema Information
#
# Table name: provider_categories
#
#  id          :integer          not null, primary key
#  titulo      :string           not null
#  imagen      :string
#  descripcion :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  status      :string           default("enabled"), not null
#

require 'rails_helper'

RSpec.describe ProviderCategory,
               type: :model do
  describe "factory" do
    subject { build :provider_category }
    it { is_expected.to be_valid }
  end
end
