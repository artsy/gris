require 'spec_helper'

describe Gris::MaximumLength do
  include Rack::Test::Methods

  module MaximumLengthSpec
    class API < Grape::API
      default_format :json

      params do
        requires :name, maximum_length: 3
      end

      get do
      end
    end
  end

  def app
    MaximumLengthSpec::API
  end

  it 'raises an error for invalid inputs' do
    get '/', name: 'hello'
    expect(last_response.status).to eq(400)
    expect(last_response.body).to eq('{"error":"name must be at most 3 characters long"}')
  end

  it 'accepts valid input' do
    get '/', name: 'hi'
    expect(last_response.status).to eq(200)
  end
end
