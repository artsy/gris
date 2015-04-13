require 'active_support'
require 'dotenv'

module Gris
  class << self
    def load_environment
      Dotenv.load(Gris.env.test? ? '.env.test' : '.env')
    end

    def env
      @_env ||= ActiveSupport::StringInquirer.new(ENV['RACK_ENV'] || 'development')
    end

    def env=(environment)
      @_env = ActiveSupport::StringInquirer.new(environment)
    end
  end
end
