require 'spec_helper'

describe Application::Service do
  include Rack::Test::Methods

  context 'CORS' do
    include_context 'with a running app'
    it 'supports options' do
      options '/', {},
              'HTTP_ORIGIN' => 'http://cors.example.com',
              'HTTP_ACCESS_CONTROL_REQUEST_HEADERS' => 'Origin, Accept, Content-Type',
              'HTTP_ACCESS_CONTROL_REQUEST_METHOD' => 'GET'

      expect(response_code).to eq 200
      expect(last_response.headers['Access-Control-Allow-Origin']).to eq 'http://cors.example.com'
      expect(last_response.headers['Access-Control-Expose-Headers']).to eq ''
    end

    it 'includes Access-Control-Allow-Origin in the response' do
      get '/', {}, 'HTTP_ORIGIN' => 'http://cors.example.com'
      expect(response_code).to eq 200
      expect(last_response.headers['Access-Control-Allow-Origin']).to eq 'http://cors.example.com'
    end

    it 'includes Access-Control-Allow-Origin in errors' do
      get '/invalid', {}, 'HTTP_ORIGIN' => 'http://cors.example.com'
      expect(response_code).to eq 404
      expect(last_response.headers['Access-Control-Allow-Origin']).to eq 'http://cors.example.com'
    end
  end
end
