require 'erb'
db = YAML.load(ERB.new(File.read('./config/database.yml')).result)[Gris.env]
ActiveRecord::Base.establish_connection(db)
ActiveRecord::Base.include_root_in_json = false
