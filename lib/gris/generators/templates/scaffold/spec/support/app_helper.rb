shared_context 'with a running app' do
  let(:app) { Rack::Builder.parse_file('config.ru').first }
end

shared_context 'with a running app and client' do
  include_context 'with a running app'

  let(:client) do
    Hyperclient.new('http://example.org/') do |client|
      client.connection(default: false) do |conn|
        conn.request :hal_json
        conn.response :json
        conn.use Faraday::Adapter::Rack, app
      end
    end
  end
end
