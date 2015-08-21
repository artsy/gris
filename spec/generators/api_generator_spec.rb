require 'spec_helper'

describe Gris::Generators::ApiGenerator do
  include_context 'with generator'
  let(:api_name) { 'article' }

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
      expected_api_file = File.join(generator_tmp_directory, 'app/endpoints/articles_endpoint.rb')
      api_code = File.read(expected_api_file)
      expect(api_code).to match(/class ArticlesEndpoint/)
    end

    it 'endpoint class uses GrisPaginator' do
      expected_api_file = File.join(generator_tmp_directory, 'app/endpoints/articles_endpoint.rb')
      api_code = File.read(expected_api_file)
      expect(api_code).to match(/paginate Article, conditions: conditions, with: ArticlesPresenter/)
    end

    it 'creates a model class' do
      expected_model_file = File.join(generator_tmp_directory, 'app/models/article.rb')
      model_code = File.read(expected_model_file)
      expect(model_code).to match(/class Article/)
    end

    it 'creates an item presenter module' do
      expected_presenter_file = File.join(generator_tmp_directory, 'app/presenters/article_presenter.rb')
      presenter_code = File.read(expected_presenter_file)
      expect(presenter_code).to match(/module ArticlePresenter/)
    end

    it 'item presenter includes Gris::Presenter' do
      presenter_file = File.join(generator_tmp_directory, 'app/presenters/article_presenter.rb')
      require "./#{presenter_file}"
      expect(ArticlePresenter).to include(Gris::Presenter)
    end

    it 'creates a collection presenter module' do
      expected_presenter_file = File.join(generator_tmp_directory, 'app/presenters/articles_presenter.rb')
      presenter_code = File.read(expected_presenter_file)
      expect(presenter_code).to match(/module ArticlesPresenter/)
    end

    it 'collection presenter includes Gris::Presenter' do
      presenter_file = File.join(generator_tmp_directory, 'app/presenters/articles_presenter.rb')
      require "./#{presenter_file}"
      expect(ArticlesPresenter).to include(Gris::Presenter)
    end

    it 'collection presenter includes Gris::PaginatedPresenter' do
      presenter_file = File.join(generator_tmp_directory, 'app/presenters/articles_presenter.rb')
      require "./#{presenter_file}"
      expect(ArticlesPresenter).to include(Gris::PaginatedPresenter)
    end

    it 'mounts new endpoint in ApplicationEndpoint' do
      expected_endpoint_file = File.join(generator_tmp_directory, 'app/endpoints/application_endpoint.rb')
      endpoint_file = File.read(expected_endpoint_file)
      expect(endpoint_file).to match(/mount ArticlesEndpoint/)
    end

    it 'adds links to RootPresenter' do
      expected_root_presenter_file = File.join(generator_tmp_directory, 'app/presenters/root_presenter.rb')
      presenter_file = File.read(expected_root_presenter_file)
      expect(presenter_file).to match(/resource_links :article/)
    end
  end

  describe 'spec' do
    it 'creates an api spec' do
      expected_api_file = File.join(generator_tmp_directory, 'spec/endpoints/articles_endpoint_spec.rb')
      api_code = File.read(expected_api_file)
      expect(api_code).to match(/describe ArticlesEndpoint/)
      expect(api_code).to match(/returns an article/)
    end

    it 'creates a fabricator' do
      expected_fabricator_file = File.join(generator_tmp_directory, 'spec/fabricators/articles_fabricator.rb')
      fabricator_code = File.read(expected_fabricator_file)
      expect(fabricator_code).to include 'Fabricator(:article) do'
    end

    it 'creates a model spec' do
      expected_model_file = File.join(generator_tmp_directory, 'spec/models/article_spec.rb')
      model_code = File.read(expected_model_file)
      expect(model_code).to match(/describe Article/)
    end
  end
end
