# taken from https://gist.github.com/gshaw/378172448fc50dec4841
# NullStorage provider for CarrierWave for use in tests.  Doesn't actually
# upload or store files but allows test to pass as if files were stored and
# the use of fixtures.
class NullStorage
  attr_reader :uploader

  def initialize(uploader)
    @uploader = uploader
  end

  def identifier
    uploader.filename
  end

  def store!(_file)
    true
  end

  def retrieve!(_identifier)
    true
  end
end

# set host on carrierwave so that it
# responds with a full url for resources
CarrierWave.configure do |config|
  schema = Rails.application.config.force_ssl ? "https:" : "http:"
  host_url = schema + "//" + Rails.application.secrets.host
  if Rails.application.secrets.port.present?
    host_url += ":" + Rails.application.secrets.port.to_s
  end

  config.asset_host = host_url

  if Rails.env.test?
    config.storage = NullStorage
    config.enable_processing = false
  end
end
