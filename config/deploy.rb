#coding: utf-8
require 'capistrano-unicorn'

#### TEST_APPにアプリ名を登録 ####
set :application, "japantravel"

# capistranoの出力をカラーに
require 'capistrano_colors'

# cap deploy時に自動で bundle installを実行
require "bundler/capistrano"
set :bundle_flags, "--no-deployment --without test development --binstubs"

# gitリポジトリの設定
#### git_remote_urlにgitのリモートURLを登録  ####
set :repository,  "git@github.com:taivn07/japantravel.git"
set :scm, :git
set :branch, "master"
set :deploy_via, :remote_cache
#### deploy_folder_path : デプロイ先のフォルダパスを設定  ####
set :copy_compression, :bz2
set :git_shallow_clone, 1
set :scm_verbose, true
set :use_sudo, false
set :deploy_to, "/workspace"
set :rails_env, "production"

# デプロイ先のサーバの設定
#### サーバのIPとSSHポートを設定 ####
server "ec2-54-200-92-142.us-west-2.compute.amazonaws.com:22", :app, :web, :db, :primary => true

# SSHユーザの設定
#### ssh_user : sshで接続するユーザー名をセット ####
set :user, 'ubuntu'
#### user_group : コマンドを実行するユーザーグループ名をセット ####
#### local_ssh_key_path : ssh_keyのパスをセット ####
ssh_options[:forward_agent] = true
ssh_options[:keys] = ["~/.ec2/taimt.pem"]
#### sudo_password : deploy 先でのssh_userのsudoパスワード ####
set :use_sudo, true
# リモートでもローカルのssh keyを使えるようにする
ssh_options[:forward_agent] = true
default_run_options[:pty] = true

set :normalize_asset_timestamps, false
# 過去のデプロイしたフォルダを履歴として保持する数
set :keep_releases, 5

set :default_environment, {
  'PATH' => "$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH"
}

# assets:precompile
namespace :assets do
  task :precompile, :roles => :web do
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rake assets:precompile"
  end
end

namespace :deploy do
  
end

# deploy ==========================
# before :deploy, "deploy:set_file_process_owner"
after :deploy, "deploy:migrate"
after :deploy, "assets:precompile"
after :deploy, "deploy:restart"
after :deploy, "deploy:cleanup" # 
after 'deploy:restart', 'unicorn:reload'    # app IS NOT preloaded
after 'deploy:restart', 'unicorn:restart'   # app preloaded
after 'deploy:restart', 'unicorn:duplicate' # before_fork hook implemented (zero downtime deployments)
