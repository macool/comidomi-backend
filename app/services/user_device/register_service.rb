class UserDevice < ActiveRecord::Base
  class RegisterService
    delegate :errors, to: :user_device

    def initialize(params, scoped)
      @scoped = scoped
      @params = params
    end

    def save
      return true if user_device_exists?
      if user_device.valid?
        user_device.transaction do
          wipe_existing_user_device!
          user_device.save!
        end
        true
      end
    end

    def user_device
      user_device ||= @scoped.new(
        uuid: @params[:uuid],
        platform: @params[:platform]
      )
    end

    private

    def user_device_exists?
      @scoped.where(
        uuid: @params[:uuid],
        platform: @params[:platform]
      ).exists?
    end

    def wipe_existing_user_device!
      UserDevice.where(
        uuid: user_device.uuid,
        platform: user_device.platform
      ).destroy_all
    end
  end
end
