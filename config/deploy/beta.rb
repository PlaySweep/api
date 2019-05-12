# server 'bud_beta', roles: %w{app db web resque_worker resque_scheduler }
server 'turner_beta', roles: %w{app db web resque_worker resque_scheduler }
set :deploy_to, "/var/www/#{fetch :application}"
after "deploy:restart", "resque:restart"
set :tmp_dir, '/home/deploy/tmp'

set :branch, 'release-20190403'
set :rails_env, 'beta'

set :linked_files, %w{config/application.yml config/database.yml config/master.key}

# role :resque_worker, "bud_beta"
# role :resque_scheduler, "bud_beta"

role :resque_worker, "turner_beta"
role :resque_scheduler, "turner_beta"

set :resque_environment_task, true
set :workers, { "*" => 4 }