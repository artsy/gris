require 'spec_helper'
require 'gris/generators/scaffold_generator'
require 'gris/cli'

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

    it 'creates a .env file with with a development database name' do
      expect(File).to exist("#{app_path}/.env")
      env_file = File.read("#{app_path}/.env")
      expect(env_file).to match(/#{app_name}_development/)
    end

    it 'creates a .env.test file with a test database name' do
      expect(File).to exist("#{app_path}/.env.test")
      env_test_file = File.read("#{app_path}/.env.test")
      expect(env_test_file).to match(/#{app_name}_test/)
    end

    it 'selects postgresql as the default database adapter' do
      database_config_file = File.read("#{app_path}/config/database.yml")
      expect(database_config_file).to match(/adapter: postgresql/)
    end

    it 'adds the pg gem in the Gemfile' do
      gemfile = File.read("#{app_path}/Gemfile")
      expect(gemfile).to match(/gem 'pg'/)
    end

    it 'generates an application endpoint' do
      expect(File).to exist("#{app_path}/app/apis/application_endpoint.rb")
    end

    context 'application_endpoint' do
      let(:application_api_file) { File.read("#{app_path}/app/apis/application_endpoint.rb") }

      it 'the application endpoint inherits from Grape::API' do
        expect(application_api_file).to match(/class ApplicationEndpoint < Grape::API/)
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

      it 'includes Grape::Roar::Representer' do
        expect(RootPresenter).to include(Grape::Roar::Representer)
      end

      it 'includes Roar::Hypermedia' do
        expect(RootPresenter).to include(Roar::Hypermedia)
      end

      it 'includes Roar::JSON::HAL' do
        expect(RootPresenter).to include(Roar::JSON::HAL)
      end
    end
  end
end
