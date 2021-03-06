require 'rubygems'
require 'spork'

Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'
  require 'jsend-rails/test/matchers'
  require 'jsend-rails/test/response'

  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  RSpec.configure do |config|
    config.fixture_path = "#{::Rails.root}/spec/fixtures"
    config.use_transactional_fixtures = true
    config.infer_base_class_for_anonymous_controllers = false
    config.order = "random"
  end

  DatabaseCleaner.strategy = :transaction
end

Spork.each_run do
  DatabaseCleaner.clean
end

def json_get(action, params = nil)
  get action, params
  @json_response = JSON.parse(response.body)
end
