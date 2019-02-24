server 'sweep_beta', roles: %w{app db web resque_worker resque_scheduler }
set :deploy_to, "/var/www/#{fetch :application}"
after "deploy:restart", "resque:restart"
set :tmp_dir, '/home/deploy/tmp'

set :branch, 'master'
set :rails_env, 'beta'

# set :linked_files, %w{config/application.yml}

role :resque_worker, "sweep_beta"
role :resque_scheduler, "sweep_beta"

set :resque_environment_task, true
set :workers, { "*" => 4 }