if File.file? 'config/database.yml'
  require 'active_record_migrations'

  ActiveRecordMigrations.configure do |c|
    c.yaml_config = 'config/database.yml'
  end

  ActiveRecordMigrations.load_tasks
end
