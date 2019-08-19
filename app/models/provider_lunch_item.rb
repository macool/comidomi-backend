# == Schema Information
#
# Table name: provider_lunch_items
#
#  id                :integer          not null, primary key
#  provider_lunch_id :integer          not null
#  kind              :string           not null
#  name              :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class ProviderLunchItem < ActiveRecord::Base
  extend Enumerize

  KINDS = [
    :mainplate,
    :soup,
    :drink,
    :dessert,
  ].freeze

  belongs_to :provider_lunch

  validates :kind,
            :name,
            presence: true

  enumerize :kind, in: KINDS, i18n_scope: "enumerize.lunch_items.kinds"
end
