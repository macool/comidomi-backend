# config valid only for current version of Capistrano
lock '3.6.1'

set :application, 'porttare-backend'
set :repo_url, 'git@github.com:macool/comidomi-backend.git'

set :slackistrano, {
  channel: '#porttare',
  webhook: 'https://hooks.slack.com/services/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'
}

set :delayed_job_prefix, 'porttare-backend'
set :delayed_job_monitor, true

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
set :branch, ENV['BRANCH'] || 'production'

set :bundle_without, %w{development test deployment}.join(' ')
# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/home/macool/porttare-backend'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: 'log/capistrano.log', color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, 'config/database.yml', 'config/secrets.yml'
append :linked_files, '.env'

# Default value for linked_dirs is []
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads', 'public/.well-known'

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

set :rbenv_ruby, '2.6.1'
set :passenger_restart_with_touch, true

# Default value for keep_releases is 5
# set :keep_releases, 5
