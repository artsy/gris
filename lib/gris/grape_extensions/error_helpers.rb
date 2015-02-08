module Gris
  module ErrorHelpers
    def error!(message, status, options = nil)
      message = { error: message }.merge(options.is_a?(String) ? { text: options } : options) if options
      throw :error, message: message, status: status
    end

    Grape::Endpoint.send :include, self if defined?(Grape)
  end
end
