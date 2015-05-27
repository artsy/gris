if ENV['DATABASE_URL']
  ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'])
else
  db = YAML.load(ERB.new(File.read('./config/database.yml')).result)[Gris.env]
  ActiveRecord::Base.establish_connection(db)
end
# prevent deprecation warning
ActiveRecord::Base.raise_in_transactional_callbacks = true
