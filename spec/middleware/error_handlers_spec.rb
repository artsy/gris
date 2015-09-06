require 'spec_helper'

describe Gris::Middleware::ErrorHandlers do
  include Rack::Test::Methods
  describe 'errors' do
    subject { Class.new(Grape::API) }

    let(:app) { subject }

    let(:fake_active_record) do
      module ActiveRecord
        class RecordNotFound < StandardError
        end
      end
    end

    before do
      subject.format :json
      subject.use Gris::Middleware::ErrorHandlers

      subject.get :generic_error do
        fail 'api error'
      end

      subject.get :gris_error do
        gris_error! 'Forbidden', 401
      end

      subject.get :error do
        error! 'Forbidden', 401
      end

      subject.get :activerecord_error do
        fail ActiveRecord::RecordNotFound
      end
    end

    it 'retuns a Not Found error for missing routes' do
      get '/bogus'
      expect(response_code).to eq 404
      expect(response_body).to eq 'Not Found'
    end

    it 'returns a formatted message for gris_error!' do
      get '/gris_error'
      expect(response_code).to eq 401
      expect(parsed_response_body['status']).to eq 401
      expect(parsed_response_body['message']).to eq 'Forbidden'
    end

    it 'returns a formatted message for error!' do
      get '/error'
      expect(response_code).to eq 401
      expect(parsed_response_body['error']).to eq 'Forbidden'
    end

    it 'returns a formatted message for ActiveRecord::RecordNotFound' do
      fake_active_record
      get '/activerecord_error'
      expect(response_code).to eq 404
      expect(parsed_response_body['status']).to eq 404
      expect(parsed_response_body['message']).to eq 'ActiveRecord::RecordNotFound'
    end

    it 'returns a formatted message when an exception is raised' do
      get '/generic_error'
      expect(response_code).to eq 500
      expect(parsed_response_body['status']).to eq 500
      expect(parsed_response_body['message']).to eq 'api error'
    end
  end
end
