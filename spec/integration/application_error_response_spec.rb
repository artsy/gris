require 'spec_helper'
require 'faraday'

describe 'application error response' do
  include_context 'with a generated app'

  it 'returns a json formatted message' do
    request = Faraday.get "http://localhost:#{app_port}/bogus"
    response = JSON.parse request.body
    expect(request.status).to eq 404
    expect(response['status']).to eq 404
    expect(response['message']).to eq ['404 Not Found']
  end
end
