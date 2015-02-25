# We are using a customized version of hashie_rails gem
# to prevent ActiveModel from raising a
# ForbiddenAttributesProtection exception when we mass
# assign attributes.
#
# https://github.com/Maxim-Filimonov/hashie_rails/pull/3
# https://github.com/dylanfareed/hashie_rails/tree/off-the-rails
#
require 'hashie_rails'

module Gris
  module CrudHelpers
    def create(type, options = {})
      instance = type.create! options[:from]
      present instance, with: options[:with]
    end

    def update(instance, options = {})
      instance.update_attributes! options[:from]
      present instance, with: options[:with]
    end

    def delete(instance, options = {})
      instance.destroy
      present instance, with: options[:with]
    end

    def permitted_params(options = {})
      options = { include_missing: false }.merge(options)
      declared(params, options)
    end

    # extend all endpoints to include this
    Grape::Endpoint.send :include, self if defined?(Grape)
  end
end
