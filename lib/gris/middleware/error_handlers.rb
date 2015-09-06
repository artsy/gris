module Gris
  class Middleware
    class ErrorHandlers
      def initialize(app)
        @app = app
      end

      def call(env)
        response = @app.call env
        case response[0]
        when 400..500
          format_error_response response
        else
          response
        end
      rescue RuntimeError => e
        error = { status: 500, message: e.message }
        error_response(error.to_json, 500)
      rescue ::ActiveRecord::RecordNotFound => e
        error = { status: 404, message: e.message }
        error_response(error.to_json, 404)
      end

      private

      def format_error_response(response)
        if response[2].respond_to? :body
          response
        else
          error = { status: response[0], message: response[2] }
          error_response(error.to_json, response[0], response[1])
        end
      end

      def error_response(message, status, headers = {})
        Rack::Response.new([message], status, headers).finish
      end
    end
  end
end
