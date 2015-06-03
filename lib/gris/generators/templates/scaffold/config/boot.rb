# load bundler
require 'bundler/setup'
require 'gris/setup'

Bundler.require(:default, Gris.env.to_sym)
