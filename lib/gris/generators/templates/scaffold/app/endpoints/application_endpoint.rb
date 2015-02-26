class ApplicationEndpoint < Grape::API
  format :json
  formatter :json, Grape::Formatter::Roar
  content_type :json, 'application/hal+json'

  helpers do
    include Gris::AuthenticationHelpers
  end

  # Adds a simple environment variable based
  # token authentication scheme to your endpoints.
  # Alternatively, this token_authentication!
  # method can be added to individual endpoints.
  #
  before do
    token_authentication!
  end

  desc 'Get the Root API Endpoint'
  get do
    present self, with: RootPresenter
  end

  # Additional mounted endpoints
end
