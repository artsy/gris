ENV['RACK_ENV'] = 'test'

require 'byebug'
require 'childprocess'
require 'gris'
require 'gris/cli'
require 'rack/test'
require 'fakefs/spec_helpers'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir['./spec/support/**/*.rb'].sort.each { |f| require f }
