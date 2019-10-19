# config/deploy/beta.rb
server 'sweep_beta1', user: 'ubuntu', roles: %w{ app db web }
set :deploy_to, "/var/www/sweep_api"
set :tmp_dir, '/home/deploy/tmp'

set :branch, 'release-20191003'
set :rails_env, 'beta'

set :linked_files, %w{config/application.yml config/database.yml config/master.key config/locales/en.yml}

set :pty, false
set :sidekiq_processes, 2
set :sidekiq_options_per_process, ["--queue critical", "--queue high", "--queue default --queue low"]

after 'deploy:starting', 'sidekiq:quiet'
after 'deploy:reverted', 'sidekiq:restart'
after 'deploy:published', 'sidekiq:restart'