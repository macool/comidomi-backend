Apipie.configure do |config|
  config.app_name                = "PorttareBackend"
  config.validate                = false
  config.api_base_url            = "/api"
  config.doc_base_url            = "/apipie"
  config.markup                  = Apipie::Markup::Markdown.new
  config.namespaced_resources    = true
  config.app_info["1.0"]         = <<-EOS
    ## porttare backend api

    resources:

    - [github repo](https://github.com/vilcabamba/porttare-backend)
  EOS

  # where is your API defined?
  config.api_controllers_matcher = File.join(
    Rails.root,
    "app",
    "controllers",
    "api",
    "**",
    "*.rb"
  )
end
