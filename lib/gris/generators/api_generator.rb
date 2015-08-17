require 'thor'
require 'active_support/all'
require 'indefinite_article'

module Gris
  module Generators
    class ApiGenerator < Thor::Group
      include Thor::Actions
      argument :name

      def name_underscore
        name.underscore
      end

      def name_tableize
        name.tableize
      end

      def output_directory
        '.'
      end

      def path_to_application_endpoint
        "#{output_directory}/app/endpoints/application_endpoint.rb"
      end

      def path_to_root_presenter
        "#{output_directory}/app/presenters/root_presenter.rb"
      end

      def append_endpoint_to_application_endpoint
        say 'Mounting new endpoint on ApplicationEndpoint.'
        insert_into_file path_to_application_endpoint, after: "# Additional mounted endpoints\n" do
          text =  "  mount #{name.classify.pluralize}Endpoint\n"
          text
        end
      end

      def append_endpoint_links_to_root_presenter
        say 'Appending links to RootPresenter.'
        insert_into_file path_to_root_presenter, after: "# Additional endpoint links\n" do
          text =  "\n"
          text << "  resource_links :#{name_underscore}\n"
          text
        end
      end

      def api
        self.class.source_root "#{File.dirname(__FILE__)}/templates/api"
        say 'Generating api...'
        directory '.', output_directory
        say 'API files created!', :green
      end
    end
  end
end
