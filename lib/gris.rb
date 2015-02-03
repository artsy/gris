# require external libraries
require 'rake'
require 'dotenv'
require 'yaml'
require 'grape'
require 'json'
require 'roar'
require 'grape-roar'
require 'roar/representer'
require 'roar/json'
require 'roar/json/hal'

# require internal files
require 'gris/deprecations'
require 'gris/grape_extensions/crud_helpers'
require 'gris/identity'
require 'gris/middleware/app_monitor'
require 'gris/output_formatters/paginated_presenter'
require 'gris/output_formatters/presenter'
require 'gris/setup'
require 'gris/version'

# load rake tasks if Rake installed
if defined?(Rake)
  load 'tasks/routes.rake'
  load 'tasks/db.rake'
end

module Gris
  class << self
    def initialize
      Gris::Deprecations.initialization_checks
    end
  end
end

Gris.initialize
