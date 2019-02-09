Airbrake.configure do |config|
  config.api_key = '4d25cc18c803023c3c9ba68f6dc26a2f'
  config.host    = 'pangi.shiriculapo.com'
  config.port    = 80
  config.secure  = config.port == 443
end
