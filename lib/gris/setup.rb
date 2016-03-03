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
        secrets = Hashie::Mash.new
        yaml = 'config/secrets.yml'
        if File.exist? yaml
          env_secrets = Hashie::Mash.load(yaml)[Gris.env]
          secrets.merge!(env_secrets) if env_secrets
        end
        secrets
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
    raise ex unless rescue_and_require && %r{^undefined class\/module (.+?)$} =~ ex.message
    self.class.const_missing(Regexp.last_match(1))
    fetch(key, options, false)
  end
end
