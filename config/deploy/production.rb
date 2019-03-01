# config/deploy/production.rb

server 'sweep', user: 'ubuntu', roles: %w{app db web resque_worker resque_scheduler }
set :deploy_to, "/var/www/sweep_api"
after "deploy:restart", "resque:restart"
set :tmp_dir, '/home/deploy/tmp'

set :branch, 'master'
set :rails_env, 'production'

set :linked_files, %w{config/database.yml}

role :resque_worker, "sweep"
role :resque_scheduler, "sweep"

set :resque_environment_task, true
set :workers, { "*" => 4 }