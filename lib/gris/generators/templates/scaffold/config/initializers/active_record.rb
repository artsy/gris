require 'erb'
if ENV['DATABASE_URL']
  ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'])
else
  db = YAML.load(ERB.new(File.read('./config/database.yml')).result)[Gris.env]
  ActiveRecord::Base.establish_connection(db)
end
ActiveRecord::Base.include_root_in_json = false
