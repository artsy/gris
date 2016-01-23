if Module.const_defined?(:ActiveRecord) &&
   (File.file?('config/database.yml') || ENV['DATABASE_URL']) &&
   File.file?('config/initializers/active_record.rb')

  require 'erb'
  require './config/initializers/active_record'
  include ActiveRecord::Tasks

  DatabaseTasks.env = Gris.env
  DatabaseTasks.db_dir = 'db'
  DatabaseTasks.migrations_paths = "#{DatabaseTasks.db_dir}/migrate"
  DatabaseTasks.seed_loader = Gris::SeedLoader.new "./#{DatabaseTasks.db_dir}/seeds.rb"
  DatabaseTasks.database_configuration = ActiveRecord::Base.configurations

  task :environment do
  end

  load 'active_record/railties/databases.rake'
end
