unless defined?(Rails)
  desc 'display all routes for Grape'
  task routes: :environment do
    require './config/application.rb'
    ApplicationEndpoint.routes.each do |api|
      version = api.route_version.ljust(20)
      method = api.route_method.ljust(10)
      path = api.route_path.ljust(40)
      description = api.route_description
      puts "#{version} #{method} #{path} # #{description}"
    end
  end
end
