# config/deploy/production.rb

server 'sweep_prod1', user: 'ubuntu', roles: %w{app db web resque_worker resque_scheduler }
set :deploy_to, "/var/www/sweep_api"
after "deploy:restart", "resque:restart", "resque:scheduler:restart"
set :tmp_dir, '/home/deploy/tmp'

set :branch, 'master'
set :rails_env, 'production'

set :linked_files, %w{config/application.yml config/database.yml config/master.key config/locales/en.yml}

role :resque_worker, ["sweep_prod1"]
role :resque_scheduler, ["sweep_prod1"]

set :resque_environment_task, true
set :workers, { "*" => 4 }