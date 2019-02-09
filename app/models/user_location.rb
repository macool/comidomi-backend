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

class UserLocation < ActiveRecord::Base
  belongs_to :user
  scope :latest, -> { order(id: :desc) }
  validates :user_id,
            :lat,
            :lon,
            presence: true
end
