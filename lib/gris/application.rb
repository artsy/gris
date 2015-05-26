require 'active_support/configurable'

module Gris
  class Application
    include ActiveSupport::Configurable
    config_accessor :use_health_middleware

    def initialize
      Gris::Deprecations.initialization_checks
      @filenames = ['', '.html', 'index.html', '/index.html']
      @rack_static = ::Rack::Static.new(
        -> { [404, {}, []] },
        root: File.expand_path('../public', __FILE__),
        urls: ['/']
        )
    end

    def self.instance(config = {})
      @instance ||= Rack::Builder.new do
        use Gris::Middleware::Health unless config[:use_health_middleware] == false
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
      response = ApplicationEndpoint.call(env)
      # Render error pages or return API response
      case response[0]
      when 404, 500
        content = @rack_static.call(env.merge('PATH_INFO' => "/errors/#{response[0]}.html"))
        [response[0], content[1], content[2]]
      else
        response
      end
    end
  end
end
