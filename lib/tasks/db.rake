unless defined?(Rails)
  task :environment do
    require './config/application.rb'
    fail 'ActiveRecord Not Found' unless Module.const_defined?(:ActiveRecord)
  end

  namespace :db do
    desc 'Migrate the database through scripts in db/migrate. Target specific version with VERSION=x'
    task migrate: :environment do
      ActiveRecord::Migrator.migrate('db/migrate', ENV['VERSION'] ? ENV['VERSION'].to_i : nil)
      Rake::Task['db:schema:dump'].invoke unless Gris.env.production?
    end

    desc 'Rollback to a previous migration. Go back multiple steps with STEP=x'
    task rollback: :environment do
      ActiveRecord::Migration.verbose = true
      step = ENV['STEP'] ? ENV['STEP'].to_i : 1
      ActiveRecord::Migrator.rollback('db/migrate', step)
    end

    desc 'Create the database'
    task create: :environment do
      db = Gris.db_connection_details
      admin_connection = db.merge(database: 'postgres',
                                  schema_search_path: 'public')
      ActiveRecord::Base.establish_connection(admin_connection)
      begin
        ActiveRecord::Base.connection.create_database(db['database'])
      rescue ActiveRecord::StatementInvalid => e
        if e.message =~ /DuplicateDatabase/
          $stderr.puts "#{admin_connection['database']} already exists"
        else
          raise
        end
      end
    end

    desc 'Delete the database'
    task drop: :environment do
      db = Gris.db_connection_details
      admin_connection = db.merge(database: 'postgres',
                                  schema_search_path: 'public')
      ActiveRecord::Base.establish_connection(admin_connection)
      ActiveRecord::Base.connection.drop_database(db['database'])
    end

    desc 'Recreate the database, load the schema, and initialize with the seed data'
    task reset: :environment do
      Rake::Task['db:drop'].invoke
      Rake::Task['db:create'].invoke
      Rake::Task['db:schema:load'].invoke
    end

    namespace :schema do
      desc 'Create a db/schema.rb file that can be portably used against any DB supported by AR'
      task dump: :environment do
        require 'active_record/schema_dumper'
        File.open(ENV['SCHEMA'] || 'db/schema.rb', 'w') do |file|
          ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, file)
        end
      end

      desc 'Load a schema.rb file into the database'
      task load: :environment do
        file = ENV['SCHEMA'] || 'db/schema.rb'
        db = Gris.db_connection_details
        admin_connection = db.merge(database: 'postgres',
                                    schema_search_path: 'public')
        ActiveRecord::Base.establish_connection(admin_connection)
        ActiveRecord::Schema.verbose = true
        load(file)
      end
    end
  end
end
