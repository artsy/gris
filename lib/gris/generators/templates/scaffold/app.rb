# load bundler
require 'bundler/setup'
Bundler.setup(:default)

require 'gris/setup'
Bundler.require(:default, Gris.env.to_sym)
require 'gris'

# load environment
Gris.load_environment

# autoload initalizers
Dir['./config/initializers/**/*.rb'].map { |file| require file }

# load middleware configs
Dir['./config/middleware/**/*.rb'].map { |file| require file }

# autoload app
relative_load_paths = %w(app/apis app/presenters app/models app/workers lib)
ActiveSupport::Dependencies.autoload_paths += relative_load_paths

module Application
  class Service
    def initialize
      @filenames = ['', '.html', 'index.html', '/index.html']
      @rack_static = ::Rack::Static.new(
        -> { [404, {}, []] },
        root: File.expand_path('../public', __FILE__),
        urls: ['/']
        )
    end

    def self.instance
      @instance ||= Rack::Builder.new do
        use Rack::Cors do
          allow do
            origins '*'
            resource '*', headers: :any, methods: :get
          end
        end
        run Application::Service.new
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
