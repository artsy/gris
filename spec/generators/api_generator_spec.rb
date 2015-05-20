require 'spec_helper'

describe Gris::Generators::ApiGenerator do
  include_context 'with generator'
  let(:api_name) { 'foo' }

  before do
    endpoints_directory_path = "#{generator_tmp_directory}/app/endpoints"
    presenters_directory_path = "#{generator_tmp_directory}/app/presenters"
    FileUtils.mkdir_p endpoints_directory_path
    FileUtils.mkdir_p presenters_directory_path
    File.open("#{endpoints_directory_path}/application_endpoint.rb", 'w+') { |file| file.write("# Additional mounted endpoints\n") }
    File.open("#{presenters_directory_path}/root_presenter.rb", 'w+') { |file| file.write("# Additional endpoint links\n") }
    Gris::CLI::Base.new.generate('api', api_name)
  end

  describe 'app' do
    it 'creates an endpoint class' do
      expected_api_file = File.join(generator_tmp_directory, 'app/endpoints/foos_endpoint.rb')
      api_code = File.read(expected_api_file)
      expect(api_code).to match(/class FoosEndpoint/)
    end

    it 'creates a model class' do
      expected_model_file = File.join(generator_tmp_directory, 'app/models/foo.rb')
      model_code = File.read(expected_model_file)
      expect(model_code).to match(/class Foo/)
    end

    it 'creates an item presenter module' do
      expected_presenter_file = File.join(generator_tmp_directory, 'app/presenters/foo_presenter.rb')
      presenter_code = File.read(expected_presenter_file)
      expect(presenter_code).to match(/module FooPresenter/)
    end

    it 'item presenter includes Gris::Presenter' do
      presenter_file = File.join(generator_tmp_directory, 'app/presenters/foo_presenter.rb')
      require "./#{presenter_file}"
      expect(FooPresenter).to include(Gris::Presenter)
    end

    it 'creates a collection presenter module' do
      expected_presenter_file = File.join(generator_tmp_directory, 'app/presenters/foos_presenter.rb')
      presenter_code = File.read(expected_presenter_file)
      expect(presenter_code).to match(/module FoosPresenter/)
    end

    it 'collection presenter includes Gris::Presenter' do
      presenter_file = File.join(generator_tmp_directory, 'app/presenters/foos_presenter.rb')
      require "./#{presenter_file}"
      expect(FoosPresenter).to include(Gris::Presenter)
    end

    it 'collection presenter includes Gris::PaginatedPresenter' do
      presenter_file = File.join(generator_tmp_directory, 'app/presenters/foos_presenter.rb')
      require "./#{presenter_file}"
      expect(FoosPresenter).to include(Gris::PaginatedPresenter)
    end

    it 'mounts new endpoint in ApplicationEndpoint' do
      expected_endpoint_file = File.join(generator_tmp_directory, 'app/endpoints/application_endpoint.rb')
      endpoint_file = File.read(expected_endpoint_file)
      expect(endpoint_file).to match(/mount FoosEndpoint/)
    end

    it 'adds links to RootPresenter' do
      expected_root_presenter_file = File.join(generator_tmp_directory, 'app/presenters/root_presenter.rb')
      presenter_file = File.read(expected_root_presenter_file)
      expect(presenter_file).to match(/link :foo do |opts|/)
      expect(presenter_file).to match(/link :foos do |opts|/)
    end
  end

  describe 'spec' do
    it 'creates an api spec' do
      expected_api_file = File.join(generator_tmp_directory, 'spec/endpoints/foos_endpoint_spec.rb')
      api_code = File.read(expected_api_file)
      expect(api_code).to match(/describe FoosEndpoint/)
    end

    it 'creates a fabricator' do
      expected_fabricator_file = File.join(generator_tmp_directory, 'spec/fabricators/foos_fabricator.rb')
      fabricator_code = File.read(expected_fabricator_file)
      expect(fabricator_code).to include 'Fabricator(:foo) do'
    end

    it 'creates a model spec' do
      expected_model_file = File.join(generator_tmp_directory, 'spec/models/foo_spec.rb')
      model_code = File.read(expected_model_file)
      expect(model_code).to match(/describe Foo/)
    end
  end
end
