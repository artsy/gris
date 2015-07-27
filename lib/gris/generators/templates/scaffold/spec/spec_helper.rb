ENV['RACK_ENV'] = 'test'

require File.expand_path('../../config/application', __FILE__)
require 'gris/rspec_extensions/response_helpers'
require 'gris/rspec_extensions/active_record_shared_connection'
ActiveRecord::Migration.maintain_test_schema!

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir['./spec/support/**/*.rb'].each { |f| require f }

RSpec.configure do |config|
  config.include Gris::RspecExtensions::ResponseHelpers
  config.mock_with :rspec
  config.expect_with :rspec

  config.before(:suite) do
    ActiveRecord::Migration.maintain_test_schema!
    DatabaseCleaner.strategy = :truncation
  end

  config.before do
    DatabaseCleaner.clean
  end
end
