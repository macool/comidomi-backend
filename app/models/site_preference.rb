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

class SitePreference < ActiveRecord::Base
  has_paper_trail

  validates :name,
            presence: true,
            uniqueness: true

  scope :by_key, ->(keyname){
    find_by!(name: keyname)
  }
end
