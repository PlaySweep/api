server 'beta1', user: "deploy", roles: %w{app db web resque_worker resque_scheduler }
set :deploy_to, "/var/www/#{fetch :application}_beta"
after "deploy:restart", "resque:restart"
set :tmp_dir, '/home/deploy/tmp'

set :branch, 'master'
set :rails_env, 'staging'

# set :linked_files, %w{config/application.yml}

role :resque_worker, "beta1"
role :resque_scheduler, "beta1"

set :resque_environment_task, true
set :workers, { "*" => 4 }