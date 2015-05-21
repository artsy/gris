require 'active_support'
require 'dotenv'

module Gris
  class << self
    def load_environment
      env_file = Gris.env.test? ? '.env.test' : '.env'
      Dotenv.overload env_file
    end

    def env
      @_env ||= ActiveSupport::StringInquirer.new(ENV['RACK_ENV'] || 'development')
    end

    def env=(environment)
      @_env = ActiveSupport::StringInquirer.new(environment)
    end

    def db_connection_details
      YAML.load(ERB.new(File.read('./config/database.yml')).result)[Gris.env]
    end

    def cache
      @_cache ||= ActiveSupport::Cache.lookup_store(:memory_store)
    end

    def cache=(store_option)
      @_cache = ActiveSupport::Cache.lookup_store(store_option)
    end
  end
end

# prevent DalliError: Unable to unmarshal value: undefined class/module
Gris.cache.instance_eval do
  def fetch(key, options = {}, rescue_and_require = true)
    super(key, options)

  rescue ArgumentError => ex
    if rescue_and_require && %r{^undefined class\/module (.+?)$} =~ ex.message
      self.class.const_missing(Regexp.last_match(1))
      fetch(key, options, false)
    else
      raise ex
    end
  end
end
