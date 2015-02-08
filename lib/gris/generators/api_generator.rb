require 'thor'
require 'active_support/all'

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

      def append_endpoint_to_application_endpoint
        say 'Mounting new endpoint on ApplicationEndpoint.'
        insert_into_file './app/endpoints/application_endpoint.rb', after: "# Additional mounted endpoints\n" do
          text =  "  mount #{name.classify.pluralize}Endpoint\n"
          text
        end
      end

      def append_endpoint_links_to_root_presenter
        say 'Appending links to RootPresenter.'
        insert_into_file './app/presenters/root_presenter.rb', after: "# Additional endpoint links\n" do
          text =  "\n"
          text << "  link :#{name_tableize} do |opts|\n"
          text << "    {\n"
          text << '      href: "#{base_url(opts)}/'
          text << "#{name_tableize}{?page,size}\",\n"
          text << "      templated: true\n"
          text << "    }\n"
          text << "  end\n"
          text << "\n"
          text << "  link :#{name_underscore} do |opts|\n"
          text << "    {\n"
          text << '      href: "#{base_url(opts)}/'
          text << "#{name_tableize}{id}\",\n"
          text << "      templated: true\n"
          text << "    }\n"
          text << "  end\n"
          text << "\n"
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
