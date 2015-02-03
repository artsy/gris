module Gris
  class Middleware
    class AppMonitor
      def initialize(app)
        @app = app
      end

      def call(env)
        if ['/health', '/health.json'].include? env['PATH_INFO']
          [200, { 'Content-type' => 'application/json' }, [Gris::Identity.health.to_json]]
        else
          @app.call(env)
        end
      end
    end
  end
end
