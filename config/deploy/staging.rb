# application name
set :application, "japantravel_stg"
# app server name
set :app1, "ec2-54-200-92-142.us-west-2.compute.amazonaws.com"
# set rails environment
set :rails_env, "staging"
# where we deploy app
set :deploy_to, "/home/ubuntu/apps/japantravel_stg"

role :web, app1
role :app, app1
role :db,  app1, :primary => true
