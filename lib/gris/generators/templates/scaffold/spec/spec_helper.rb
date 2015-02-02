ENV['RACK_ENV'] = 'test'

require 'webmock/rspec'
require 'rack/test'
require 'gris/rspec_extensions/response_helpers'

require './app'
# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir['./spec/support/**/*.rb'].each { |f| require f }

RSpec.configure do |config|
  config.include Gris::RspecExtensions::ResponseHelpers
  config.mock_with :rspec
  config.expect_with :rspec

  config.before(:suite) do
    ActiveRecord::Migration.maintain_test_schema!
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.after(:each) do |_example|
    DatabaseCleaner.clean
  end
end
