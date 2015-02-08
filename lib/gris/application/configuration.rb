module Gris
  class Application
    class Configuration
      attr_accessor :use_app_monitor

      def initialize(*)
        super
        @use_app_monitor = false
      end

      def app_monitor
        puts "@use_app_monitor: #{@use_app_monitor}"
      end
    end
  end
end
