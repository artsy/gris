require 'spec_helper'
require 'gris'
require 'rack/test'

describe Gris::PresenterLinkHelpers do
  include Rack::Test::Methods

  module MyRootPresenter
    include Gris::Presenter

    resource_links :printmaker, [:account_id], '/{id}?account_id={account_id}'
    resource_links :painter, [:sort]
    resource_links :sculptor

    endpoint_link :painting, template_options: [:account_id, :user_id]
    endpoint_link :sculpture
    endpoint_link :self, namespace: 'drawings', uri_template: '/{id}'
  end

  class MyApplicationEndpoint < Grape::API
    format :json
    formatter :json, Grape::Formatter::Roar
    get do
      present self, with: MyRootPresenter
    end
  end

  def app
    MyApplicationEndpoint.new
  end

  before do
    get '/'
    @result = Hashie::Mash.new JSON.parse(last_response.body)
  end

  it 'includes Gris::PresenterLinkHelpers' do
    expect(RootPresenter).to include(Gris::PresenterLinkHelpers)
  end

  it 'returns uri template for resource_links with additional arguments' do
    expect(@result['_links']['painters']['href']).to eq "#{Gris::Identity.base_url}/painters{?sort,page,size}"
    expect(@result['_links']['painters']['templated']).to eq true
    expect(@result['_links']['painter']['href']).to eq "#{Gris::Identity.base_url}/painters/{id}"
    expect(@result['_links']['painter']['templated']).to eq true
  end

  it 'returns uri template for resource_links with resource_uri_template' do
    expect(@result['_links']['printmakers']['href']).to eq "#{Gris::Identity.base_url}/printmakers{?account_id,page,size}"
    expect(@result['_links']['printmakers']['templated']).to eq true
    expect(@result['_links']['printmaker']['href']).to eq "#{Gris::Identity.base_url}/printmakers/{id}?account_id={account_id}"
    expect(@result['_links']['printmaker']['templated']).to eq true
  end

  it 'returns uri template for resource_links without additional arguments' do
    expect(@result['_links']['sculptors']['href']).to eq "#{Gris::Identity.base_url}/sculptors{?page,size}"
    expect(@result['_links']['sculptors']['templated']).to eq true
    expect(@result['_links']['sculptor']['href']).to eq "#{Gris::Identity.base_url}/sculptors/{id}"
    expect(@result['_links']['sculptor']['templated']).to eq true
  end

  it 'returns uri template for endpoint_link with template_options' do
    expect(@result['_links']['painting']['href']).to eq "#{Gris::Identity.base_url}/painting{?account_id,user_id}"
    expect(@result['_links']['painting']['templated']).to eq true
  end

  it 'returns uri template for endpoint_link without additional arguments' do
    expect(@result['_links']['sculpture']['href']).to eq "#{Gris::Identity.base_url}/sculpture"
    expect(@result['_links']['sculpture']['templated']).to be_nil
  end

  it 'returns uri template for endpoint_link with namespace and uri_template options' do
    expect(@result['_links']['self']['href']).to eq "#{Gris::Identity.base_url}/drawings/{id}"
    expect(@result['_links']['self']['templated']).to be_nil
  end
end
