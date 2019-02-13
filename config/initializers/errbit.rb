Airbrake.configure do |config|
  config.api_key = '44efb53b680822cba2a41aa454f5ab1c'
  config.host    = 'pangi.shiriculapo.com'
  config.port    = 80
  config.secure  = config.port == 443
end
