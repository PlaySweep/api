# config/deploy/production.rb

server 'turnerv2', user: 'ubuntu', roles: %w{ app db web }
set :deploy_to, "/var/www/sweep_api"
set :tmp_dir, '/home/deploy/tmp'

set :branch, 'release20200501'
set :rails_env, 'production'

set :linked_files, %w{config/application.yml config/database.yml config/master.key config/locales/en.yml}

set :pty, false
set :sidekiq_processes, 2
set :sidekiq_options_per_process, ["--queue critical", "--queue high", "--queue default --queue low"]

# after 'deploy:starting', 'sidekiq:quiet'
# after 'deploy:reverted', 'sidekiq:restart'
# after 'deploy:published', 'sidekiq:restart'