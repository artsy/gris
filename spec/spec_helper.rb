ENV['RACK_ENV'] = 'test'

require 'gris/setup'
require 'gris'

require 'byebug'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir['./spec/support/**/*.rb'].sort.each { |f| require f }
