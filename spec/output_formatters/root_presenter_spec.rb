require 'spec_helper'
require 'gris'
require 'rack/test'

describe Gris::RootPresenter do
  include Rack::Test::Methods

  module RootPresenter
    include Gris::RootPresenter
    resource_links :painter, [:sort]
    endpoint_link :painting, [:account_id]
    resource_links :sculptor
    endpoint_link :sculpture
  end

  class ApplicationEndpoint < Grape::API
    format :json
    formatter :json, Grape::Formatter::Roar
    get do
      present self, with: RootPresenter
    end
  end

  def app
    ApplicationEndpoint.new
  end

  before do
    get '/'
    @result = Hashie::Mash.new JSON.parse(last_response.body)
  end

  it 'returns uri template for resource_links with additional arguments' do
    expect(@result['_links']['painters']['href']).to eq "#{Gris::Identity.base_url}/painters{?sort,page,size}"
    expect(@result['_links']['painters']['templated']).to eq true
    expect(@result['_links']['painter']['href']).to eq "#{Gris::Identity.base_url}/painters/{id}"
    expect(@result['_links']['painter']['templated']).to eq true
  end

  it 'returns uri template for resource_links without additional arguments' do
    expect(@result['_links']['sculptors']['href']).to eq "#{Gris::Identity.base_url}/sculptors{?page,size}"
    expect(@result['_links']['sculptors']['templated']).to eq true
    expect(@result['_links']['sculptor']['href']).to eq "#{Gris::Identity.base_url}/sculptors/{id}"
    expect(@result['_links']['sculptor']['templated']).to eq true
  end

  it 'returns uri template for endpoint_link with additional arguments' do
    expect(@result['_links']['painting']['href']).to eq "#{Gris::Identity.base_url}/painting{?account_id}"
    expect(@result['_links']['painting']['templated']).to eq true
  end

  it 'returns uri template for endpoint_link without additional arguments' do
    expect(@result['_links']['sculpture']['href']).to eq "#{Gris::Identity.base_url}/sculpture"
    expect(@result['_links']['sculpture']['templated']).to be_nil
  end
end
