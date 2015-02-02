unless defined?(Rails)
  desc 'display all routes for Grape'
  task :routes do
    ApplicationEndpoint.routes.each do |api|
      method = api.route_method.ljust(10)
      path = api.route_path.ljust(40)
      description = api.route_description
      puts "     #{method} #{path} # #{description}"
    end
  end
end
