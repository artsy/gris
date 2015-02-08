# load bundler
require 'bundler/setup'
Bundler.setup(:default)

require 'gris/setup'
Bundler.require(:default, Gris.env.to_sym)

# load environment
Gris.load_environment

# autoload initalizers
Dir['./config/initializers/**/*.rb'].map { |file| require file }

# autoload app
relative_load_paths = %w(app/endpoints app/presenters app/models)
ActiveSupport::Dependencies.autoload_paths += relative_load_paths
