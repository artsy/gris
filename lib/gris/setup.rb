require 'active_support'

module Gris
  class << self
    def env
      @_env ||= ActiveSupport::StringInquirer.new(ENV['RACK_ENV'] || 'development')
    end

    def env=(environment)
      @_env = ActiveSupport::StringInquirer.new(environment)
    end

    # adapted from https://github.com/rails/rails/blob/master/railties/lib/rails/application.rb
    # Returns secrets added to config/secrets.yml.
    def secrets
      @secrets ||= begin
        secrets = ActiveSupport::OrderedOptions.new
        yaml = 'config/secrets.yml'
        if File.exist?(yaml)
          require 'erb'
          # safe_load yaml, whitelist_classes = [], whitelist_symbols = [], aliases = false, filename = nil
          all_secrets = YAML.safe_load(ERB.new(IO.read(yaml)).result, [], [], true) || {}
          env_secrets = all_secrets[Gris.env]
          secrets.merge!(env_secrets.symbolize_keys) if env_secrets
        end
        secrets
      end
    end

    def db_connection_details
      if ENV['DATABASE_URL']
        ActiveRecord::ConnectionAdapters::ConnectionSpecification::ConnectionUrlResolver.new(ENV['DATABASE_URL']).to_hash
      else
        YAML.load(ERB.new(File.read('./config/database.yml')).result)[Gris.env]
      end
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
