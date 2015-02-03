require 'gris/deprecations/gris_setup'

module Gris
  class Deprecations
    def self.initialization_checks
      gris_setup_check
    end
  end
end
