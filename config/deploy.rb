require "capistrano/ext/multistage"
require 'capistrano-unicorn'

set :application, "japantravel"
set :repository,  "git@github.com:taivn07/japantravel.git"

#set environment list
set :stages, ["staging", "production"]

# set default environtment
set :default_stage, "production"

# set branch
set :scm, :git
set :branch, "master"

# set user
set :user, "ubuntu"

# not need use sudo
set :use_sudo, false

# how to make update
set :deploy_via, :copy

# ssh options
# set :ssh_options, { :forward_agent => true }
default_run_options[:pty] = true
ssh_options[:forward_agent] = true
ssh_options[:auth_methods] = ["publickey"]
ssh_options[:keys] = ["~/.ec2/taimt.pem"]

# keep how many release should store on your server
set :keep_releases, 5

# rbenv environment set
set :default_environment, {
  'PATH' => "$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH"
}

namespace :deploy do
    task :create_directory do
      run <<-CMD
        mkdir -p #{shared_path}/sockets
      CMD
    end
end

namespace :db do
  task :reset do
    run <<-CMD
      cd #{current_path};
      bundle exec rake db:migrate RAILS_ENV=#{rails_env}
    CMD
  end

  task :seed do
    run <<-CMD
      cd #{current_path};
      bundle exec rake db:seed RAILS_ENV=#{rails_env}
    CMD
  end
end

namespace :solr do
  task :start do
    run <<-CMD
      cd #{current_path};
      bundle exec rake sunspot:solr:start RAILS_ENV=#{rails_env}
    CMD
  end

  task :reindex do
    run <<-CMD
      cd #{current_path};
      bundle exec rake sunspot:solr:reindex RAILS_ENV=#{rails_env}
    CMD
  end
end

after 'deploy:restart', 'unicorn:reload'    # app IS NOT preloaded
after 'deploy:restart', 'unicorn:restart'   # app preloaded
after 'deploy:restart', 'unicorn:duplicate' # before_fork hook implemented (zero downtime deployments)

after 'deploy:create_symlink', 'deploy:create_directory'