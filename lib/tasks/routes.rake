unless defined?(Rails)
  desc 'display all routes for Grape'
  task routes: :environment do
    require './config/application.rb'
    ApplicationEndpoint.routes.each do |api|
      if api.respond_to? :version
        version     = api.version.to_s.ljust(20)
        method      = api.request_method.ljust(10)
        path        = api.path.ljust(40)
        description = api.description
        puts "#{version} #{method} #{path} # #{description}"
      else
        version     = api.route_version.to_s.ljust(20)
        method      = api.route_method.ljust(10)
        path        = api.route_path.ljust(40)
        description = api.route_description
        puts "#{version} #{method} #{path} # #{description}"
      end
    end
  end
end
