module Gris
  module PaginatedPresenter
    def self.included(base)
      base.class_eval do
        include Gris::Presenter

        property :total_count
        property :total_pages
        property :current_page
        property :next_page
        property :prev_page

        link :self do |opts|
          "#{request_url(opts)}?#{query_string_for_page(represented.current_page, opts)}"
        end

        link :next do |opts|
          "#{request_url(opts)}?#{query_string_for_page(represented.next_page, opts)}" if represented.next_page
        end

        link :prev do |opts|
          "#{request_url(opts)}?#{query_string_for_page(represented.prev_page, opts)}" if represented.prev_page
        end

        private

        def request_url(opts)
          request = Grape::Request.new(opts[:env])
          "#{request.base_url}#{opts[:env]['PATH_INFO']}"
        end

        def query_string_for_page(page, opts)
          qs = Rack::Utils.parse_nested_query(opts[:env]['QUERY_STRING'])
          qs['page'] = page
          qs.to_query
        end
      end
    end
  end
end
