require 'thor'
require 'gris/generators'
require 'gris/version'

module Gris
  class CLI
    class Generate < Thor
      register(
        Generators::ApiGenerator,
        'api',
        'api <api_name>',
        'Generate a Grape API, Model and Presenter'
      )

      register(
        Generators::MigrationGenerator,
        'migration',
        'migration <migration_name> [field[:type][:index] field[:type][:index]]',
        'Generate a Database Migration'
      )
    end
  end
  class CLI
    class Base < Thor
      desc 'version', 'Returns the Gris version number'
      def version
        say Gris::VERSION
      end

      desc 'console [environment]', 'Start the Gris console'
      options aliases: 'c'
      def console(environment = nil)
        ENV['RACK_ENV'] = environment || 'development'

        require 'racksh/init'

        begin
          require 'pry'
          interpreter = Pry
        rescue LoadError
          require 'irb'
          require 'irb/completion'
          interpreter = IRB
          # IRB uses ARGV and does not expect these arguments.
          ARGV.delete('console')
          ARGV.delete(environment) if environment
        end

        Rack::Shell.init

        $0 = "#{$PROGRAM_NAME} console"
        interpreter.start
      end

      register(
        Generators::ScaffoldGenerator,
        'new',
        'new <app_name> [app_path]',
        'Generates a scaffold for a new Gris service'
      )

      desc 'generate api <api_name>', 'Create a Grape API, Model and Representer'
      subcommand 'generate api', Gris::CLI::Generate

      desc 'generate migration <migration_name> [field[:type][:index] field[:type][:index]]', 'Create a Database Migration'
      subcommand 'generate', Gris::CLI::Generate
    end
  end
end
