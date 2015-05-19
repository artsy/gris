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
      process_datetime_params(params) if respond_to?(:process_datetime_params)
      declared(params, options)
    end

    # extend all endpoints to include this
    Grape::Endpoint.send :include, self if defined?(Grape)
  end
end
