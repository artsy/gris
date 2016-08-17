require 'spec_helper'

describe Gris::Generators::ScaffoldGenerator do
  let(:app_name) { 'my_test_app' }
  let(:app_path) { 'spec/my_different_directory' }
  let(:options) { {} }

  before do
    scaffold = Gris::CLI::Base.new(args, options)
    scaffold.invoke(:new)
  end

  after do
    if args[1] # if app_path exists, delete dir at app_path
      FileUtils.rm_rf(args[1])
    else # otherwise delete dir at app_name
      FileUtils.rm_rf(args[0])
    end
  end

  context 'given only an app name' do
    let(:args) { [app_name] }

    it 'creates a scaffold app in a directory that mirrors the app name' do
      expect(Dir).to exist(app_name)
    end
  end

  context 'given an app name and a directory' do
    let(:args) { [app_name, app_path] }

    it 'creates a scaffold app in a directory of my choosing' do
      expect(Dir).to exist(app_path)
    end

    it 'creates a Procfile file with puma ' do
      expect(File).to exist("#{app_path}/Procfile")
      env_file = File.read("#{app_path}/Procfile")
      expect(env_file).to match(/web: bundle exec puma/)
    end

    it 'selects postgresql as the default database adapter' do
      database_config_file = File.read("#{app_path}/config/database.yml")
      expect(database_config_file).to match(/adapter: postgresql/)
    end

    it 'generates a db/seeds.rb file' do
      seed_file = File.read("#{app_path}/db/seeds.rb")
      expect(seed_file).to match(/all the record creation needed to seed the database/)
    end

    it 'adds ruby 2.3.1 to Gemfile' do
      gemfile = File.read("#{app_path}/Gemfile")
      expect(gemfile).to match(/ruby '2.3.1'/)
    end

    it 'adds the puma gem in the Gemfile' do
      gemfile = File.read("#{app_path}/Gemfile")
      expect(gemfile).to match(/gem 'puma'/)
    end

    it 'adds the gris_paginator gem in the Gemfile' do
      gemfile = File.read("#{app_path}/Gemfile")
      expect(gemfile).to match(/gem 'gris_paginator'/)
    end

    it 'generates a config/application.rb file' do
      expect(File).to exist("#{app_path}/config/application.rb")
    end

    context 'config/application.rb' do
      let(:config_application_file) { File.read("#{app_path}/config/application.rb") }

      it 'adds directories in /app to ActiveSupport::Dependencies.autoload_paths' do
        expect(config_application_file).to include "relative_load_paths = Dir.glob 'app/**/*/'"
        expect(config_application_file).to include(
          'ActiveSupport::Dependencies.autoload_paths += relative_load_paths'
        )
      end
      it 'includes optional middleware configs' do
        expect(config_application_file).to include('config.use_error_handlers_middleware = true')
        expect(config_application_file).to include('config.use_health_middleware = true')
      end
    end

    it 'generates an application endpoint' do
      expect(File).to exist("#{app_path}/app/endpoints/application_endpoint.rb")
    end

    context 'application_endpoint' do
      let(:application_api_file) { File.read("#{app_path}/app/endpoints/application_endpoint.rb") }

      it 'the application endpoint inherits from Grape::API' do
        expect(application_api_file).to match(/class ApplicationEndpoint < Grape::API/)
      end

      it 'the application endpoint uses hal+json content_type' do
        expect(application_api_file).to include "content_type :json, 'application/hal+json'"
      end

      it 'the application endpoint enables cascading' do
        expect(application_api_file).to include 'cascade true'
      end

      it 'mounts the RootPresenter' do
        expect(application_api_file).to match(/present self, with: RootPresenter/)
      end

      it 'uses Grape::Formatter::Roar json formatter' do
        expect(application_api_file).to match(/formatter :json, Grape::Formatter::Roar/)
      end
    end

    it 'generates a root presenter' do
      expect(File).to exist("#{app_path}/app/presenters/root_presenter.rb")
    end

    context 'root_presenter' do
      let(:root_presenter_file) { File.read("#{app_path}/app/presenters/root_presenter.rb") }

      before do
        require "./#{app_path}/app/presenters/root_presenter.rb"
      end

      it 'defines RootPresenter module' do
        expect(root_presenter_file).to match(/module RootPresenter/)
      end

      it 'includes Gris::Presenter' do
        expect(RootPresenter).to include(Gris::Presenter)
      end

      it 'includes link to self' do
        expect(root_presenter_file).to match(/link :self do/)
      end

      it 'includes link to health middleware' do
        expect(root_presenter_file).to match(/endpoint_link :health/)
      end
    end
  end
end
