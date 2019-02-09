require 'pusher'

Pusher.key = Rails.application.secrets.pusher_key
Pusher.secret = Rails.application.secrets.pusher_secret
Pusher.app_id = Rails.application.secrets.pusher_app_id
Pusher.logger = Rails.logger
Pusher.encrypted = true
