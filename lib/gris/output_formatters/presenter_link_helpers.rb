module Gris
  module PresenterLinkHelpers
    def self.included(base)
      base.class_eval do
        def self.resource_links(name, args = [], resource_uri_template = '/{id}')
          args += %w(page size)
          endpoint_link(
            name.to_s.pluralize,
            template_options: args, templated: true
          )
          endpoint_link(
            name,
            namespace: name.to_s.pluralize,
            uri_template: resource_uri_template,
            templated: true
          )
        end

        def self.endpoint_link(name, options = {})
          namespace = options[:namespace] || name
          template_options = options[:template_options] || []
          uri_template = options[:uri_template] || format_template_options(template_options)
          link name do
            link = {
              href: "#{Gris::Identity.base_url}/#{namespace}#{uri_template}"
            }
            link[:templated] = true if !!options[:templated] || !template_options.blank?
            link
          end
        end

        private

        def self.format_template_options(template_options = [])
          return unless template_options.any?
          "{?#{template_options.join(',')}}"
        end
      end
    end
  end
end
