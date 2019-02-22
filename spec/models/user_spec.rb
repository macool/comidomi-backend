# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  provider               :string           default("email"), not null
#  uid                    :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  name                   :string
#  nickname               :string
#  image                  :string
#  email                  :string
#  info                   :json
#  credentials            :json
#  tokens                 :json
#  created_at             :datetime
#  updated_at             :datetime
#  fecha_nacimiento       :date
#  ciudad                 :string
#  privileges             :text             default([]), is an Array
#  custom_image           :string
#  agreed_tos             :boolean          default(FALSE)
#  current_place_id       :integer
#  phone_number           :string
#

require 'rails_helper'

RSpec.describe User,
               type: :model do
  describe "factory" do
    subject { build :user }
    it { is_expected.to be_valid }
  end

  describe "email validation" do
    describe "email provider" do
      subject { create :user, provider: "email" }

      it {
        subject.email = ""
        is_expected.to_not be_valid
      }

      it {
        existing_user = create :user, provider: "email"
        subject.email = existing_user.email
        is_expected.to_not be_valid
      }
    end

    describe "non-email provider" do
      subject { build :user, uid: "UN1QUE", provider: "twitter", email: nil }
      it { is_expected.to be_valid }
    end
  end
end
