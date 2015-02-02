class ApplicationEndpoint < Grape::API
  format :json
  formatter :json, Grape::Formatter::Roar

  desc 'Get the Root API Endpoint'
  get do
    present self, with: RootPresenter
  end
end
