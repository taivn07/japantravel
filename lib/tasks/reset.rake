namespace :db do
  namespace :test do
    task :reset do
      if (ENV['RAILS_ENV'] == "test")
        Rake::Task['db:drop'].invoke
        Rake::Task['db:create'].invoke
        Rake::Task['db:migrate'].invoke
      else
        system("rake db:test:reset RAILS_ENV=test")
      end
    end
  end
end
