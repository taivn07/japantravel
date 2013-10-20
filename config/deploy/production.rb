# application name
set :application, "japantravel"
# app server name
set :app1, "ec2-54-200-92-142.us-west-2.compute.amazonaws.com"
# set rails environment
set :rails_env, "production"
# where we deploy app
set :deploy_to, "/home/ubuntu/apps/japantravel"

role :web, app1
role :app, app1
role :db,  app1, :primary => true
