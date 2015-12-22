if ENV['DATABASE_URL']
  ActiveRecord::Base.establish_connection ENV['DATABASE_URL']
else
  configurations = YAML.load ERB.new(File.read('./config/database.yml')).result
  ActiveRecord::Base.establish_connection configurations[Gris.env]
  ActiveRecord::Base.configurations = configurations
end

# prevent deprecation warning
ActiveRecord::Base.raise_in_transactional_callbacks = true
