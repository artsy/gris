require 'active_support/configurable'

module Gris
  class Application
    include ActiveSupport::Configurable
    config_accessor :use_health_middleware
    config_accessor :use_error_handlers_middleware

    def self.instance(config = {})
      @instance ||= Rack::Builder.new do
        use Gris::Middleware::Health unless config[:use_health_middleware] == false
        use Gris::Middleware::ErrorHandlers unless config[:use_error_handlers_middleware] == false

        use Rack::Cors do
          allow do
            origins '*'
            resource '*', headers: :any, methods: :get
          end
        end
        run Gris::Application.new
      end.to_app
    end

    def call(env)
      ApplicationEndpoint.call(env)
    end
  end
end
