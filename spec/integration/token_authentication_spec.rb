require 'spec_helper'
require 'hyperclient'

describe 'token authentication' do
  include_context 'with a generated app'

  let(:client_url) { "http://localhost:#{app_port}" }
  let(:client) { Hyperclient.new(client_url) }

  it 'returns a forbidden error' do
    request = Faraday.get client_url
    response = JSON.parse request.body
    expect(response['error']).to include 'Forbidden'
  end

  context 'with correct token query params' do
    it 'returns the root presenter' do
      client.params['token'] = 'replace-me'
      expect(client._links.self._url).to eq client_url
    end
  end

  context 'with correct Http-Authorization headers' do
    it 'returns the root presenter' do
      client.headers['Http-Authorization'] = 'replace-me'
      expect(client._links.self._url).to eq client_url
    end
  end
end
