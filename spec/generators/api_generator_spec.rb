require 'spec_helper'
require 'gris/generators/api_generator'
require 'gris/cli'

describe Gris::Generators::ApiGenerator do
  include_context 'with generator'
  let(:api_name) { 'foo' }

  before do
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
