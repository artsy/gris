module Gris
  module ErrorHelpers
    def gris_error!(message, status)
      response = { status: status, message: message }
      throw :error, message: response, status: status
    end

    Grape::Endpoint.send :include, self if defined?(Grape)
  end
end
