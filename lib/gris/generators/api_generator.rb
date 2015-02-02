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

      def api
        self.class.source_root "#{File.dirname(__FILE__)}/templates/api"
        say 'Generating api...'
        directory '.', output_directory
        say 'API files created!', :green
        say 'Note that you will need to mount this new endpoint in your ApplicationEndpoint.', :green
      end
    end
  end
end
