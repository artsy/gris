require 'roar/representer'
require 'roar/json'
require 'roar/json/hal'

module Gris
  module Presenter
    def self.included(base)
      base.class_eval do
        include Roar::JSON::HAL
        include Roar::Hypermedia
        include Grape::Roar::Representer

        private

        def request_url(opts)
          request = Grape::Request.new(opts[:env])
          "#{request.base_url}#{opts[:env]['PATH_INFO']}"
        end
      end
    end
  end
end
