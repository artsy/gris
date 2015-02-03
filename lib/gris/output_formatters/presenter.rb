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
      end
    end
  end
end
