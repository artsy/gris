module Gris
  module RootPresenter
    def self.included(base)
      base.class_eval do
        include Gris::Presenter

        def self.resource_links(name, args = [])
          args += %w(page size)
          link name.to_s.pluralize do
            link = {
              href: "#{Gris::Identity.base_url}/#{name.to_s.pluralize}#{format_args(args)}",
              templated: true
            }
            link
          end
          link name do
            {
              href: "#{Gris::Identity.base_url}/#{name.to_s.pluralize}/{id}",
              templated: true
            }
          end
        end

        def self.endpoint_link(name, args = [])
          link name do
            link = {
              href: "#{Gris::Identity.base_url}/#{name}#{format_args(args)}"
            }
            link[:templated] = true unless args.blank?
            link
          end
        end

        private

        def format_args(args = [])
          return unless args.any?
          "{?#{args.join(',')}}"
        end
      end
    end
  end
end
