#!/bin/sh

export RAILS_ENV=production
git pull origin master
bundle exec rake db:migrate
bundle exec rake assets:precompile:all
sudo restart japantravel_api
