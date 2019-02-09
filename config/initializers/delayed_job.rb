non_delayed_envs = %w(test staging)
Delayed::Worker.delay_jobs = !non_delayed_envs.include?(Rails.env)
