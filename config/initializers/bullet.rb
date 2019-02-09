if Rails.env.development? || Rails.env.test?
  Bullet.enable = true
  Bullet.rails_logger = true
end

if Rails.env.development?
  Bullet.bullet_logger = true
end
