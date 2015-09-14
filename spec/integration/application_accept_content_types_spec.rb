require 'spec_helper'
require 'faraday'

describe 'cascade api versions' do
  include_context 'with a generated app'

  it 'returns a the default content_type' do
    request = Faraday.get "http://localhost:#{app_port}/", {}, 'Accept' => 'vnd.bogus-v2+json'
    expect(request.to_hash[:response_headers]['content-type']).to eq(
      'application/hal+json'
    )
    expect(request.status).to eq 200
  end
end
