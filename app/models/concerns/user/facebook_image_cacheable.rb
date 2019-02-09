class User < ActiveRecord::Base
  module FacebookImageCacheable
    extend ActiveSupport::Concern

    included do
      after_save :delay_fb_image_caching!
      attr_accessor :need_to_cache_fb_image
    end

    def will_cache_facebook_image!
      if provider == "facebook"
        self.need_to_cache_fb_image = true
      end
    end

    private

    def delay_fb_image_caching!
      if need_to_cache_fb_image
        delay.cache_facebook_image!
      end
    end

    def cache_facebook_image!
      image_uri = URI.parse image
      check_facebook_api_version!(image_uri)
      image_uri.query = { type: 'large', redirect: 0 }.to_param
      response = JSON.parse(Net::HTTP.get(image_uri))
      self.remote_custom_image_url = response["data"]["url"]
      save validate: false
    end

    def check_facebook_api_version!(image_uri)
      api_version = /v2.6/
      right_version = image_uri.path =~ api_version
      if !right_version
        Airbrake.notify('FB graph version changed!', {
          image_uri: image_uri.to_s
        })
      end
    end
  end
end
