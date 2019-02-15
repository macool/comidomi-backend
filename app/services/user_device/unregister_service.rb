class UserDevice < ActiveRecord::Base
  class UnregisterService
    delegate :errors, to: :user_device

    def initialize(params, scoped)
      @scoped = scoped
      @params = params
    end

    def unregister!
      return true if user_device.blank?
      user_device.destroy
    end

    def user_device
      @user_device ||= @scoped.find_by(
        uuid: @params[:uuid],
        platform: @params[:platform]
      )
    end
  end
end
