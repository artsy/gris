class ApplicationEndpoint < Grape::API
  format :json
  formatter :json, Grape::Formatter::Roar
  content_type :json, 'application/hal+json'

  desc 'Get the Root API Endpoint'
  get do
    present self, with: RootPresenter
  end

  # Additional mounted endpoints
end
